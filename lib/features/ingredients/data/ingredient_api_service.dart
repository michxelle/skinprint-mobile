import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:skinprint/features/ingredients/models/ingredient_info.dart';

class IngredientApiService {
  static const String _cosingHost = 'api.bdapi.app';

  static const String _pubChemHost = 'pubchem.ncbi.nlm.nih.gov';

  static const Map<String, String> _headers = {
    'Accept': 'application/json',
    'User-Agent': 'Skinprint/0.1 Flutter portfolio prototype',
  };

  Future<List<IngredientInfo>> searchIngredients(String query) async {
    final cleanedQuery = query.trim();

    if (cleanedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.https(_cosingHost, '/api/public/cosing/search', {
      'q': cleanedQuery,
      'limit': '20',
      'regulated_only': 'false',
    });

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 429) {
      throw Exception(
        'Too many ingredient requests. Please try again shortly.',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to search ingredients '
        '(HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected ingredient API response.');
    }

    final rows = decoded['rows'];

    if (rows is! List) {
      return [];
    }

    return rows
        .whereType<Map<String, dynamic>>()
        .map(IngredientInfo.fromCosingJson)
        .toList();
  }

  Future<IngredientInfo?> getIngredientInfo(String ingredientName) async {
    final results = await searchIngredients(ingredientName);

    if (results.isEmpty) {
      final description = await _getPubChemDescription(ingredientName);

      if (description == null) {
        return null;
      }

      return IngredientInfo(
        name: ingredientName,
        slug: '',
        casNumber: null,
        ecNumber: null,
        functions: const [],
        description: description,
      );
    }

    final bestMatch = _chooseBestMatch(ingredientName, results);

    final description = await _getPubChemDescription(bestMatch.name);

    return bestMatch.copyWith(description: description);
  }

  IngredientInfo _chooseBestMatch(String query, List<IngredientInfo> results) {
    final normalizedQuery = _normalizeName(query);

    for (final result in results) {
      if (_normalizeName(result.name) == normalizedQuery) {
        return result;
      }
    }

    return results.first;
  }

  Future<String?> _getPubChemDescription(String ingredientName) async {
    try {
      final encodedName = Uri.encodeComponent(ingredientName);

      final uri = Uri.parse(
        'https://$_pubChemHost/rest/pug/'
        'compound/name/$encodedName/'
        'description/JSON',
      );

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final informationList = decoded['InformationList'];

      if (informationList is! Map<String, dynamic>) {
        return null;
      }

      final information = informationList['Information'];

      if (information is! List || information.isEmpty) {
        return null;
      }

      final first = information.first;

      if (first is! Map<String, dynamic>) {
        return null;
      }

      final description = first['Description'];

      if (description == null) {
        return null;
      }

      final text = description.toString().trim();

      return text.isEmpty ? null : text;
    } catch (_) {
      return null;
    }
  }

  String _normalizeName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
