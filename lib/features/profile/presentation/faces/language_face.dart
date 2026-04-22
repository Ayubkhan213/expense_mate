import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/language/bloc/language_bloc.dart';
import 'package:spendio/core/language/bloc/language_event.dart';
import 'package:spendio/core/language/bloc/language_state.dart'
    show LanguageState;
import 'package:spendio/core/language/language_persistence.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/l10n/app_localizations.dart';

class LanguageFace extends StatefulWidget {
  final bool isFirstLaunch;
  const LanguageFace({super.key, this.isFirstLaunch = false});

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
  State<LanguageFace> createState() => _LanguageFaceState();
}

class _LanguageFaceState extends State<LanguageFace> {
  late String _selectedCode = LanguagePersistence.getLocale();

  Future<void> _proceedToOnboarding() async {
    await LanguagePersistence.saveLocale(_selectedCode);
    if (mounted) {
      context.read<LanguageBloc>().add(
        ChangeLanguageEvent(Locale(_selectedCode)),
      );
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteName.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ─── KEY FIX: BlocBuilder wraps the ENTIRE Scaffold ───────────────────
    // Previously BlocBuilder only wrapped `body`, so bottomNavigationBar
    // never rebuilt when the language BLoC state changed.
    // Now the whole Scaffold (including bottomNavigationBar) rebuilds,
    // and AppLocalizations.of(context) returns the correct translations.
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final primary = theme.colorScheme.primary;
        final topPad = MediaQuery.of(context).padding.top;
        final t = AppLocalizations.of(context)!;

        const expandedHeight = 200.0;
        final collapsedHeight = 64.0 + topPad;

        final selectedLang = LanguageFace._languages.firstWhere(
          (l) => l.code == _selectedCode,
          orElse: () => LanguageFace._languages[0],
        );

        return Scaffold(
          backgroundColor: isDark
              ? theme.colorScheme.background
              : const Color(0xFFF2F4F8),

          // ── Bottom bar now inside BlocBuilder → rebuilds on lang change ──
          bottomNavigationBar: widget.isFirstLaunch
              ? SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.background
                          : const Color(0xFFF2F4F8),
                      border: Border(
                        top: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedLang.flag,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedLang.nativeName,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _NextButton(
                          primary: primary,
                          label: t.next, // ← correct translation every rebuild
                          onTap: _proceedToOnboarding,
                        ),
                      ],
                    ),
                  ),
                )
              : null,

          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: expandedHeight,
                collapsedHeight: 64,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: !widget.isFirstLaunch,
                leading: widget.isFirstLaunch
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                flexibleSpace: LayoutBuilder(
                  builder: (ctx, constraints) {
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
                          if (expandedOpacity > 0)
                            Opacity(
                              opacity: expandedOpacity,
                              child: _ExpandedHeader(
                                primary: primary,
                                topPad: topPad,
                                availableHeight: current,
                                currentCode: _selectedCode,
                                isFirstLaunch: widget.isFirstLaunch,
                              ),
                            ),
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
                                      if (_selectedCode.isNotEmpty)
                                        Text(
                                          selectedLang.flag,
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    t.selectLanguage,
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

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final lang = LanguageFace._languages[index];
                    final isSelected = _selectedCode == lang.code;

                    return _LanguageCard(
                      lang: lang,
                      isSelected: isSelected,
                      isDark: isDark,
                      onTap: () {
                        setState(() => _selectedCode = lang.code);

                        if (!widget.isFirstLaunch) {
                          // Settings: apply immediately
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
                        } else {
                          // First-launch: fire BLoC so the UI previews the
                          // selected language immediately (Next btn, header, etc.)
                          context.read<LanguageBloc>().add(
                            ChangeLanguageEvent(lang.locale),
                          );
                        }
                      },
                    );
                  }, childCount: LanguageFace._languages.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Next button
// ─────────────────────────────────────────────────────────────────────────────
class _NextButton extends StatefulWidget {
  final Color primary;
  final String label;
  final VoidCallback onTap;
  const _NextButton({
    required this.primary,
    required this.label,
    required this.onTap,
  });
  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
  );
  late final Animation<double> _s = Tween<double>(
    begin: 1.0,
    end: 0.95,
  ).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap();
      },
      onTapCancel: () => _c.reverse(),
      child: ScaleTransition(
        scale: _s,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: widget.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Expanded header
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandedHeader extends StatelessWidget {
  final Color primary;
  final double topPad;
  final double availableHeight;
  final String currentCode;
  final bool isFirstLaunch;

  const _ExpandedHeader({
    required this.primary,
    required this.topPad,
    required this.availableHeight,
    required this.currentCode,
    required this.isFirstLaunch,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: isFirstLaunch ? 16 : 40),
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
                              t.chooseLanguageSubtitle,
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
                              t.currentLanguage,
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

// ─────────────────────────────────────────────────────────────────────────────
// Language card
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Language option model
// ─────────────────────────────────────────────────────────────────────────────
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
