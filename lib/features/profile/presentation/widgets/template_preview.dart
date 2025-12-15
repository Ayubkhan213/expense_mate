import 'package:flutter/material.dart';

class TemplatePreview extends StatelessWidget {
  final ThemeData theme;

  const TemplatePreview({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // --- Fake AppBar ---
            Container(
              height: 35,
              color: theme.colorScheme.primary,
              alignment: Alignment.center,
              child: Text("AppBar", style: theme.primaryTextTheme.titleSmall),
            ),

            const SizedBox(height: 8),

            // --- Fake card preview ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 12,
                    width: 70,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 50,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
