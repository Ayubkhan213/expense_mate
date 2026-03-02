import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';

class LanguageFace extends StatelessWidget {
  const LanguageFace({super.key});

  static const _languages = [
    _LanguageOption(
      locale: Locale('en'),
      code: 'en',
      nativeName: 'English',
      englishName: 'English',
      flag: '🇬🇧',
      subtitle: 'United Kingdom / United States',
    ),
    _LanguageOption(
      locale: Locale('ar'),
      code: 'ar',
      nativeName: 'العربية',
      englishName: 'Arabic',
      flag: '🇸🇦',
      subtitle: 'Arabic — RTL',
      isRtl: true,
    ),
    _LanguageOption(
      locale: Locale('ur'),
      code: 'ur',
      nativeName: 'اردو',
      englishName: 'Urdu',
      flag: '🇵🇰',
      subtitle: 'Urdu — RTL',
      isRtl: true,
    ),
    _LanguageOption(
      locale: Locale('fr'),
      code: 'fr',
      nativeName: 'Français',
      englishName: 'French',
      flag: '🇫🇷',
      subtitle: 'France',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    const expandedHeight = 200.0;
    final collapsedHeight = 64.0 + topPad;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: isDark
          ? theme.colorScheme.background
          : const Color(0xFFF2F4F8),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── Hero SliverAppBar ──
              SliverAppBar(
                expandedHeight: expandedHeight,
                collapsedHeight: 64,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final current = constraints.maxHeight;
                    final progress =
                        ((expandedHeight - current) /
                                (expandedHeight - collapsedHeight))
                            .clamp(0.0, 1.0);
                    final expandedOpacity = (1.0 - progress).clamp(0.0, 1.0);
                    final collapsedOpacity = ((progress - 0.20) / 0.30).clamp(
                      0.0,
                      1.0,
                    );

                    return ClipRect(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Expanded
                          if (expandedOpacity > 0)
                            Opacity(
                              opacity: expandedOpacity,
                              child: _ExpandedHeader(
                                primary: primary,
                                topPad: topPad,
                                availableHeight: current,
                                currentCode: state.locale,
                              ),
                            ),
                          // Collapsed
                          if (collapsedOpacity > 0)
                            Opacity(
                              opacity: collapsedOpacity,
                              child: Container(
                                color: primary,
                                padding: EdgeInsets.only(top: topPad),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 52,
                                    right: 16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.menuLanguage,
                                          style: AppTextStyles.h5.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      // Show active flag in collapsed
                                      if (state.locale.isNotEmpty)
                                        Text(
                                          _languages
                                              .firstWhere(
                                                (l) => l.code == state.locale,
                                                orElse: () => _languages[0],
                                              )
                                              .flag,
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Section label ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    'SELECT LANGUAGE',
                    style: AppTextStyles.overline.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.45,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              // ── Language cards ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final lang = _languages[index];
                    final isSelected = state.locale == lang.code;

                    return _LanguageCard(
                      lang: lang,
                      isSelected: isSelected,
                      isDark: isDark,
                      onTap: () {
                        context.read<LanguageBloc>().add(
                          ChangeLanguageEvent(lang.locale),
                        );
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Text(
                                    lang.flag,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${lang.englishName} selected',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                      },
                    );
                  }, childCount: _languages.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Expanded header
// ─────────────────────────────────────────
class _ExpandedHeader extends StatelessWidget {
  final Color primary;
  final double topPad;
  final double availableHeight;
  final String currentCode;

  const _ExpandedHeader({
    required this.primary,
    required this.topPad,
    required this.availableHeight,
    required this.currentCode,
  });

  @override
  Widget build(BuildContext context) {
    final currentLang = LanguageFace._languages.firstWhere(
      (l) => l.code == currentCode,
      orElse: () => LanguageFace._languages[0],
    );
    final t = AppLocalizations.of(context)!;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withValues(alpha: 0.82)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: availableHeight,
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back button space (leading is handled by SliverAppBar)
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.menuLanguage,
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Choose your preferred language',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Current language pill
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          currentLang.flag,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current language',
                              style: AppTextStyles.captionSmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.65),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentLang.nativeName,
                              style: AppTextStyles.h5.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Active',
                                style: AppTextStyles.overline.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Language card
// ─────────────────────────────────────────
class _LanguageCard extends StatelessWidget {
  final _LanguageOption lang;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.lang,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.08)
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? primary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            splashColor: primary.withValues(alpha: 0.08),
            highlightColor: primary.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Flag in a subtle container
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Names
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.nativeName,
                              style: AppTextStyles.h6.copyWith(
                                color: isSelected
                                    ? primary
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (lang.isRtl) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'RTL',
                                  style: AppTextStyles.overline.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          lang.englishName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          lang.subtitle,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Selection indicator
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isSelected
                        ? Container(
                            key: const ValueKey('selected'),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        : Container(
                            key: const ValueKey('unselected'),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.25,
                                ),
                                width: 1.5,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Language option model
// ─────────────────────────────────────────
class _LanguageOption {
  final Locale locale;
  final String code;
  final String nativeName;
  final String englishName;
  final String flag;
  final String subtitle;
  final bool isRtl;

  const _LanguageOption({
    required this.locale,
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.flag,
    required this.subtitle,
    this.isRtl = false,
  });
}
