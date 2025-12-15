import 'package:expense_mate/core/app_export.dart';

class LanguageFace extends StatelessWidget {
  const LanguageFace({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = {
      AppConstants.english: const Locale('en'),
      AppConstants.arabic: const Locale('ar'),
      AppConstants.urdu: const Locale('ur'),
      AppConstants.french: const Locale('fr'),
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Language")),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return ListView(
            children: languages.entries.map((entry) {
              final languageName = entry.key;
              final locale = entry.value;

              return ListTile(
                title: Text(languageName),
                trailing: state.locale == locale.languageCode
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  context.read<LanguageBloc>().add(ChangeLanguageEvent(locale));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$languageName selected")),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
