import 'package:expense_mate/core/app_export.dart';

abstract class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final Locale locale;
  ChangeLanguageEvent(this.locale);
}
