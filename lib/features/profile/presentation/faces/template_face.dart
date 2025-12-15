import 'package:expense_mate/core/app_export.dart';

class TemplateFace extends StatelessWidget {
  const TemplateFace({super.key});

  @override
  Widget build(BuildContext context) {
    final themeList = AppThemes.lightThemes; // 5 themes preview

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Theme Template"),

        // 🔥 Added Dark / Light Mode Switch
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Switch(
                value: state.isDark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ToggleDarkModeEvent(value));
                },
              );
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: themeList.length,
        itemBuilder: (context, index) {
          final theme = themeList[index];

          return GestureDetector(
            onTap: () {
              context.read<ThemeBloc>().add(ChangeThemeEvent(index));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Theme ${index + 1} applied")),
              );
            },
            child: Column(
              children: [
                TemplatePreview(theme: theme),
                const SizedBox(height: 8),
                Text(
                  "Theme ${index + 1}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
