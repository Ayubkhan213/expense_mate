import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendio/core/language/bloc/language_event.dart';
import 'package:spendio/core/language/bloc/language_state.dart';
import 'package:spendio/core/language/language_persistence.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc()
    : super(LanguageState(locale: LanguagePersistence.getLocale())) {
    on<ChangeLanguageEvent>((event, emit) async {
      await LanguagePersistence.saveLocale(event.locale.languageCode);
      emit(LanguageState(locale: event.locale.languageCode)); // only string
    });
  }
}
