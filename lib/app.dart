import 'package:flutter/material.dart';

import '/core/theme/app_theme.dart';
import '/features/navigation/screens/main_shell.dart';

class SkinprintApp
    extends StatelessWidget {
  const SkinprintApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skinprint',
      debugShowCheckedModeBanner:
          false,
      theme:
          AppTheme.lightTheme,
      home:
          const MainShell(),
    );
  }
}