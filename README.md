# expense_mate

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
<!-- lib/
│
├── core/ -->
│   ├── theme/
│   │    ├── bloc/
│   │    │    ├── theme_bloc.dart
│   │    │    ├── theme_event.dart
│   │    │    └── theme_state.dart
│   │    ├── themes/
│   │    │    ├── theme1/
│   │    │    │    ├── light_theme.dart
│   │    │    │    └── dark_theme.dart
│   │    │    ├── theme2/
│   │    │    │    ├── light_theme.dart
│   │    │    │    └── dark_theme.dart
│   │    │    ├── theme3/
│   │    │    │    ├── light_theme.dart
│   │    │    │    └── dark_theme.dart
│   │    │    ├── theme4/
│   │    │    │    ├── light_theme.dart
│   │    │    │    └── dark_theme.dart
│   │    │    └── theme5/
│   │    │         ├── light_theme.dart
│   │    │         └── dark_theme.dart
│   │    ├── app_themes.dart
│   │    ├── theme_persistence.dart
│   │    └── theme_constants.dart
│   │
│   ├── utils/
│   ├── services/
│   ├── constants/
│   ├── network/
│   ├── widgets/
│   └── error/
│
├── features/
│   ├── home/
│   │    ├── data/
│   │    │    ├── models/
│   │    │    ├── repos/
│   │    │    └── datasources/
│   │    ├── domain/
│   │    │    ├── entities/
│   │    │    ├── repos/
│   │    │    └── usecases/
│   │    ├── presentation/
│   │    │    ├── screens/
│   │    │    ├── widgets/
│   │    │    └── pages/
│   │    └── bloc/
│   │         ├── home_bloc.dart
│   │         ├── home_event.dart
│   │         └── home_state.dart
│   │
│   ├── records/
│   │    ├── data/
│   │    │    ├── models/
│   │    │    ├── repos/
│   │    │    └── datasources/
│   │    ├── domain/
│   │    │    ├── entities/
│   │    │    ├── repos/
│   │    │    └── usecases/
│   │    ├── presentation/
│   │    │    ├── screens/
│   │    │    ├── widgets/
│   │    │    └── pages/
│   │    └── bloc/
│   │         ├── records_bloc.dart
│   │         ├── records_event.dart
│   │         └── records_state.dart
│   │
│   ├── analytics/
│   │    ├── data/
│   │    │    ├── models/
│   │    │    ├── repos/
│   │    │    └── datasources/
│   │    ├── domain/
│   │    │    ├── entities/
│   │    │    ├── repos/
│   │    │    └── usecases/
│   │    ├── presentation/
│   │    │    ├── screens/
│   │    │    ├── widgets/
│   │    │    └── pages/
│   │    └── bloc/
│   │         ├── analytics_bloc.dart
│   │         ├── analytics_event.dart
│   │         └── analytics_state.dart
│   │
│   └── profile/
│        ├── data/
│        │    ├── models/
│        │    ├── repos/
│        │    └── datasources/
│        ├── domain/
│        │    ├── entities/
│        │    ├── repos/
│        │    └── usecases/
│        ├── presentation/
│        │    ├── screens/
│        │    ├── widgets/
│        │    └── pages/
│        └── bloc/
│             ├── profile_bloc.dart
│             ├── profile_event.dart
│             └── profile_state.dart
│
├── main.dart
└── injection_container.dart

 └── features/
      ├── home/
      │     ├── data/
      │     │     ├── models/
      │     │     ├── repos/
      │     │     └── datasources/
      │     ├── domain/
      │     ├── presentation/
      │     └── bloc/
      │
      ├── records/
      │     ├── data/
      │     ├── domain/
      │     ├── presentation/
      │     └── bloc/
      │
      ├── analytics/
      │     ├── data/
      │     ├── domain/
      │     ├── presentation/
      │     └── bloc/
      │
      └── profile/
            ├── data/
            ├── domain/
            ├── presentation/
            └── bloc/
 -->