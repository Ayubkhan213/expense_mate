import 'package:expense_mate/core/app_export.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc()
    : super(LanguageState(locale: LanguagePersistence.getLocale())) {
    on<ChangeLanguageEvent>((event, emit) async {
      await LanguagePersistence.saveLocale(event.locale.languageCode);
      emit(LanguageState(locale: event.locale.languageCode)); // only string
    });
  }
}
