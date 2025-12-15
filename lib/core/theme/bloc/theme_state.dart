import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final int themeIndex;
  final bool isDark;

  const ThemeState({required this.themeIndex, required this.isDark});

  factory ThemeState.initial() =>
      const ThemeState(themeIndex: 0, isDark: false);

  ThemeState copyWith({int? themeIndex, bool? isDark}) {
    return ThemeState(
      themeIndex: themeIndex ?? this.themeIndex,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  List<Object> get props => [themeIndex, isDark];
}
