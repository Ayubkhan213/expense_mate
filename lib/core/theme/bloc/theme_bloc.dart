import 'package:bloc/bloc.dart';

import 'package:spendio/core/theme/themes/theme_persistence.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<LoadSavedThemeEvent>(_onLoadSaved);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ToggleDarkModeEvent>(_onToggleDark);

    add(LoadSavedThemeEvent());
  }

  void _onLoadSaved(LoadSavedThemeEvent event, Emitter<ThemeState> emit) {
    final index = ThemePersistence.getThemeIndex();
    final isDark = ThemePersistence.getDarkMode();

    emit(ThemeState(themeIndex: index, isDark: isDark));
  }

  void _onChangeTheme(ChangeThemeEvent event, Emitter<ThemeState> emit) {
    ThemePersistence.saveThemeIndex(event.themeIndex);

    emit(state.copyWith(themeIndex: event.themeIndex));
  }

  void _onToggleDark(ToggleDarkModeEvent event, Emitter<ThemeState> emit) {
    ThemePersistence.saveDarkMode(event.isDark);

    emit(state.copyWith(isDark: event.isDark));
  }
}
