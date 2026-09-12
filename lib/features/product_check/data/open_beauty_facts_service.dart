import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:skinprint/features/product_check/models/beauty_product.dart';

class OpenBeautyFactsService {
  static const String _host = 'world.openbeautyfacts.org';

  static const Map<String, String> _headers = {
    'Accept': 'application/json',
    'User-Agent': 'Skinprint/1.0 (Flutter; https://github.com/michxelle/skinprint-mobile)',
  };

  Future<List<BeautyProduct>> searchProducts(
    String query,
  ) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    // if the user entered only numbers, assume they entered a barcode
    final isBarcode = RegExp(r'^\d{8,14}$').hasMatch(
      trimmedQuery,
    );

    if (isBarcode) {
      final product = await getProductByBarcode(
        trimmedQuery,
      );

      if (product == null) {
        return [];
      }

      return [product];
    }

    final uri = Uri.https(
      _host,
      '/cgi/search.pl',
      {
        'search_terms': trimmedQuery,
        'search_simple': '1',
        'action': 'process',
        'json': '1',
        'page_size': '15',
        'fields':
            'code,product_name,brands,ingredients_text,image_front_url',
      },
    );

    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to search products right now '
        '(HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Unexpected API response.',
      );
    }

    final productsJson = decoded['products'];

    if (productsJson is! List) {
      return [];
    }

    return productsJson
        .whereType<Map<String, dynamic>>()
        .map(BeautyProduct.fromJson)
        .where(
          (product) =>
              product.name != 'Unnamed product',
        )
        .toList();
  }

  Future<BeautyProduct?> getProductByBarcode(
    String barcode,
  ) async {
    final uri = Uri.https(
      _host,
      '/api/v2/product/$barcode.json',
      {
        'fields':
            'code,product_name,brands,ingredients_text,image_front_url',
      },
    );

    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to load this product '
        '(HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Unexpected API response.',
      );
    }

    final status = decoded['status'];

    if (status != 1) {
      return null;
    }

    final productJson = decoded['product'];

    if (productJson is! Map<String, dynamic>) {
      return null;
    }

    final productData = Map<String, dynamic>.from(
      productJson,
    );

    productData['code'] ??= barcode;

    return BeautyProduct.fromJson(productData);
  }
}