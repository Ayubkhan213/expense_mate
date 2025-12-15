import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSavedThemeEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final int themeIndex;

  ChangeThemeEvent(this.themeIndex);

  @override
  List<Object?> get props => [themeIndex];
}

class ToggleDarkModeEvent extends ThemeEvent {
  final bool isDark;

  ToggleDarkModeEvent(this.isDark);

  @override
  List<Object?> get props => [isDark];
}
