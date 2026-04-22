import 'dart:io';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/utils/translation_helper.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionDetailFace extends StatefulWidget {
  final TransactionModel transaction;
  final String heroTag;

  const TransactionDetailFace({
    super.key,
    required this.transaction,
    required this.heroTag,
  });

  @override
  State<TransactionDetailFace> createState() => _TransactionDetailFaceState();
}

class _TransactionDetailFaceState extends State<TransactionDetailFace>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final List<Animation<double>> _itemAnimations;
  final ValueNotifier<bool> _imageExpanded = ValueNotifier(false);

  static const int _itemCount = 7;
  static const double _expandedHeight = 230.0;
  static const double _collapsedHeight = 64.0;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _itemAnimations = List.generate(_itemCount, (i) {
      final start = i * 0.10;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );
    });
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _imageExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final txn = widget.transaction;
    final isIncome = txn.type.toString().contains('income');
    final amountColor = isIncome
        ? const Color(0xFF10b981)
        : const Color(0xFFef4444);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark
          ? colorScheme.background
          : const Color(0xFFF4F6FB),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // ── SliverPersistentHeader handles scroll collapse ────────────
          // Hero lives INSIDE the delegate's build() as a RenderBox,
          // which is valid because SliverPersistentHeader wraps it in a sliver.
          SliverPersistentHeader(
            pinned: true,
            delegate: _TxnSliverDelegate(
              transaction: txn,
              isIncome: isIncome,
              amountColor: amountColor,
              topPad: topPad,
              expandedHeight: _expandedHeight,
              collapsedHeight: _collapsedHeight,
              heroTag: widget.heroTag,
            ),
          ),

          // ── Body content ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimatedItem(
                    animation: _itemAnimations[0],
                    child: _InfoCard(
                      txn: txn,
                      isDark: isDark,
                      colorScheme: colorScheme,
                      isIncome: isIncome,
                      amountColor: amountColor,
                      t: t,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _AnimatedItem(
                    animation: _itemAnimations[1],
                    child: Row(
                      children: [
                        Expanded(
                          child: _MiniCard(
                            icon: Icons.calendar_today_rounded,
                            label: t.date,
                            value: DateFormat('MMM dd, yyyy').format(txn.date),
                            isDark: isDark,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MiniCard(
                            icon: _paymentIcon(txn.paymentMethod.name),
                            label: t.payment,
                            value: context.trMethod(txn.paymentMethod.name),
                            isDark: isDark,
                            colorScheme: colorScheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AnimatedItem(
                    animation: _itemAnimations[2],
                    child: Row(
                      children: [
                        Expanded(
                          child: _MiniCard(
                            icon: isIncome
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            label: t.type,
                            value: isIncome ? t.income : t.expense,
                            valueColor: amountColor,
                            isDark: isDark,
                            colorScheme: colorScheme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MiniCard(
                            icon: txn.isDebt
                                ? Icons.account_balance_rounded
                                : Icons.check_circle_rounded,
                            label: t.status,
                            value: txn.isDebt ? t.debt : t.settled,
                            valueColor: txn.isDebt
                                ? colorScheme.secondary
                                : const Color(0xFF10b981),
                            isDark: isDark,
                            colorScheme: colorScheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (txn.items.first.note != null &&
                      txn.items.first.note!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _AnimatedItem(
                      animation: _itemAnimations[3],
                      child: _NoteCard(
                        note: txn.items.first.note!,
                        isDark: isDark,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                  if (txn.tags != null && txn.tags!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _AnimatedItem(
                      animation: _itemAnimations[4],
                      child: _TagsCard(
                        tags: txn.tags!,
                        isDark: isDark,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                  if (txn.attachmentPath != null &&
                      txn.attachmentPath!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _AnimatedItem(
                      animation: _itemAnimations[5],
                      child: _AttachmentCard(
                        path: txn.attachmentPath!,
                        isDark: isDark,
                        colorScheme: colorScheme,
                        imageExpanded: _imageExpanded,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _AnimatedItem(
                    animation: _itemAnimations[6],
                    child: _IdFooter(
                      id: txn.id,
                      createdAt: txn.createdAt,
                      isDark: isDark,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _paymentIcon(String method) {
    switch (method.toLowerCase()) {
      case 'card':
        return Icons.credit_card_rounded;
      case 'bank':
        return Icons.account_balance_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.payments_rounded;
    }
  }
}

// =============================================================================
// SliverPersistentHeaderDelegate
// Hero lives inside here — this is valid because the delegate's build()
// returns a plain RenderBox, and SliverPersistentHeader converts it to a sliver.
// =============================================================================
class _TxnSliverDelegate extends SliverPersistentHeaderDelegate {
  final TransactionModel transaction;
  final bool isIncome;
  final Color amountColor;
  final double topPad;
  final double expandedHeight;
  final double collapsedHeight;
  final String heroTag;

  const _TxnSliverDelegate({
    required this.transaction,
    required this.isIncome,
    required this.amountColor,
    required this.topPad,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.heroTag,
  });

  @override
  double get minExtent => collapsedHeight + topPad;
  @override
  double get maxExtent => expandedHeight + topPad;

  @override
  bool shouldRebuild(_TxnSliverDelegate old) =>
      old.transaction != transaction ||
      old.amountColor != amountColor ||
      old.heroTag != heroTag;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final totalShrink = maxExtent - minExtent;
    final progress = (shrinkOffset / totalShrink).clamp(0.0, 1.0);
    final expandedOpacity = (1.0 - progress / 0.60).clamp(0.0, 1.0);
    final collapsedOpacity = ((progress - 0.50) / 0.35).clamp(0.0, 1.0);
    final bottomRadius = Radius.circular(32.0 * (1.0 - progress));

    final gradEnd = HSLColor.fromColor(amountColor)
        .withLightness(
          (HSLColor.fromColor(amountColor).lightness - 0.14).clamp(0.0, 1.0),
        )
        .toColor();

    // Hero wraps the gradient container here — this is a plain RenderBox,
    // which is fine inside SliverPersistentHeader's build().
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (_, anim, __, ___, ____) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [amountColor, gradEnd],
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [amountColor, gradEnd],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: bottomRadius,
            bottomRight: bottomRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: amountColor.withValues(alpha: 0.25 + 0.15 * progress),
              blurRadius: 16.0 + 12.0 * progress,
              offset: Offset(0, 6.0 + 6.0 * progress),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Decorative circles
            if (expandedOpacity > 0)
              Opacity(
                opacity: expandedOpacity,
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: -20,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Expanded content
            if (expandedOpacity > 0)
              Opacity(
                opacity: expandedOpacity,
                child: _ExpandedContent(
                  transaction: transaction,
                  isIncome: isIncome,
                  topPad: topPad,
                ),
              ),

            // Collapsed bar
            if (collapsedOpacity > 0)
              Opacity(
                opacity: collapsedOpacity,
                child: _CollapsedBar(
                  transaction: transaction,
                  isIncome: isIncome,
                  amountColor: amountColor,
                  topPad: topPad,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Expanded full header content
// =============================================================================
class _ExpandedContent extends StatelessWidget {
  final TransactionModel transaction;
  final bool isIncome;
  final double topPad;

  const _ExpandedContent({
    required this.transaction,
    required this.isIncome,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    final sign = isIncome ? '+' : '-';
    final category = context.tr(transaction.items.first.category);
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          topPad + 8,
          16,
          16,
        ), // Reduced bottom padding from 20 to 16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Changed from max to min
          children: [
            Row(
              children: [
                _HeaderBtn(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                _HeaderBtn(
                  icon: Icons.copy_rounded,
                  size: 16,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: transaction.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.transactionIdCopied),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16), // Reduced from 20 to 16
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.32),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getIcon(),
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Added
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1, // Added to prevent overflow
                        overflow: TextOverflow.ellipsis, // Added
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isIncome ? '▲ ${t.income}' : '▼ ${t.expense} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Reduced from 20 to 16
            Text(
              '$sign${CurrencyFormatter.format(transaction.totalAmount)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                height: 1,
              ),
              maxLines: 1, // Added
              overflow: TextOverflow.ellipsis, // Added
            ),
            const SizedBox(height: 4), // Reduced from 6 to 4
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(transaction.date),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
              maxLines: 1, // Added
              overflow: TextOverflow.ellipsis, // Added
            ),
          ],
        ),
      ),
    );
  }

  String _getIcon() {
    final cat = transaction.items.first.category.toLowerCase();
    if (cat.contains('food') || cat.contains('restaurant')) return '🍔';
    if (cat.contains('salary')) return '💰';
    if (cat.contains('transport')) return '🚗';
    if (cat.contains('shopping')) return '🛒';
    return '💵';
  }
}

// =============================================================================
// Collapsed one-row bar
// =============================================================================
class _CollapsedBar extends StatelessWidget {
  final TransactionModel transaction;
  final bool isIncome;
  final Color amountColor;
  final double topPad;

  const _CollapsedBar({
    required this.transaction,
    required this.isIncome,
    required this.amountColor,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    final sign = isIncome ? '+' : '-';
    final category = context.tr(transaction.items.first.category);
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(top: topPad),
      height: 64 + topPad, // Add explicit height constraint
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _HeaderBtn(
              icon: Icons.arrow_back_rounded,
              size: 16,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(_getIcon(), style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(transaction.date),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Text(
                '$sign${CurrencyFormatter.format(transaction.totalAmount)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _HeaderBtn(
              icon: Icons.copy_rounded,
              size: 15,
              onTap: () {
                Clipboard.setData(ClipboardData(text: transaction.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.transactionIdCopied),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getIcon() {
    final cat = transaction.items.first.category.toLowerCase();
    if (cat.contains('food') || cat.contains('restaurant')) return '🍔';
    if (cat.contains('salary')) return '💰';
    if (cat.contains('transport')) return '🚗';
    if (cat.contains('shopping')) return '🛒';
    return '💵';
  }
}

// =============================================================================
// Shared header button
// =============================================================================
class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _HeaderBtn({required this.icon, required this.onTap, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}

// =============================================================================
// Body cards
// =============================================================================
class _InfoCard extends StatelessWidget {
  final TransactionModel txn;
  final bool isDark;
  final ColorScheme colorScheme;
  final bool isIncome;
  final Color amountColor;
  final AppLocalizations t;

  const _InfoCard({
    required this.txn,
    required this.isDark,
    required this.colorScheme,
    required this.isIncome,
    required this.amountColor,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      isDark: isDark,
      colorScheme: colorScheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            icon: Icons.receipt_long_rounded,
            label: t.transactionDetails,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 14),
          ...txn.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr(item.category),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(item.amount),
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (txn.items.length > 1) ...[
            Divider(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              height: 20,
            ),
            Row(
              children: [
                Text(
                  t.total,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  CurrencyFormatter.format(txn.totalAmount),
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String note;
  final bool isDark;
  final ColorScheme colorScheme;

  const _NoteCard({
    required this.note,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _SectionCard(
      isDark: isDark,
      colorScheme: colorScheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            icon: Icons.sticky_note_2_rounded,
            label: t.note,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          Text(
            note,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsCard extends StatelessWidget {
  final List<String> tags;
  final bool isDark;
  final ColorScheme colorScheme;

  const _TagsCard({
    required this.tags,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _SectionCard(
      isDark: isDark,
      colorScheme: colorScheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            icon: Icons.label_rounded,
            label: t.tags,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final String path;
  final bool isDark;
  final ColorScheme colorScheme;
  final ValueNotifier<bool> imageExpanded;

  const _AttachmentCard({
    required this.path,
    required this.isDark,
    required this.colorScheme,
    required this.imageExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    final exists = file.existsSync();
    final t = AppLocalizations.of(context)!;
    return _SectionCard(
      isDark: isDark,
      colorScheme: colorScheme,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _SectionLabel(
                  icon: Icons.image_rounded,
                  label: t.attachment,
                  colorScheme: colorScheme,
                ),
                const Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: imageExpanded,
                  builder: (_, expanded, __) => GestureDetector(
                    onTap: () => imageExpanded.value = !expanded,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        expanded ? t.collapse : t.expand,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (!exists)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                t.imageFileNotFound,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 13,
                ),
              ),
            )
          else
            ValueListenableBuilder<bool>(
              valueListenable: imageExpanded,
              builder: (_, expanded, __) => GestureDetector(
                onTap: () => imageExpanded.value = !expanded,
                child: AnimatedCrossFade(
                  firstChild: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.file(
                      file,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  secondChild: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.file(
                      file,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IdFooter extends StatelessWidget {
  final String id;
  final DateTime createdAt;
  final bool isDark;
  final ColorScheme colorScheme;

  const _IdFooter({
    required this.id,
    required this.createdAt,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          _MetaRow(
            label: t.transactionId,
            value: '${id.substring(0, 8).toUpperCase()}...',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 6),
          _MetaRow(
            label: t.created,
            value: DateFormat('MMM dd, yyyy HH:mm').format(createdAt),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _MetaRow({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.45),
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isDark;
  final ColorScheme colorScheme;

  const _MiniCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.colorScheme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final ColorScheme colorScheme;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _SectionCard({
    required this.isDark,
    required this.colorScheme,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: colorScheme.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: colorScheme.primary.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _AnimatedItem extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _AnimatedItem({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }
}
