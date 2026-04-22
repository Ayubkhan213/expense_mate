import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';
import 'package:spendio/core/common/custom_snackbar.dart';
import 'package:spendio/core/data/data_sources/local/debt_local_datasource.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:spendio/l10n/app_localizations.dart';

class DebtEditSheet extends StatefulWidget {
  final DebtModel debt;

  const DebtEditSheet({super.key, required this.debt});

  static void show(BuildContext context, DebtModel debt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: DebtEditSheet(debt: debt),
      ),
    );
  }

  @override
  State<DebtEditSheet> createState() => _DebtEditSheetState();
}

class _DebtEditSheetState extends State<DebtEditSheet> {
  late TextEditingController _nameController;
  late DateTime _expectedReturnDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.debt.personName);
    _expectedReturnDate = widget.debt.expectedReturnDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    final isBorrowed = widget.debt.debtType == DebtType.borrowed;
    final color = isBorrowed
        ? const Color(0xFFef4444)
        : const Color(0xFF10b981);

    // ✅ Fix overflow — wrap in SingleChildScrollView + respect keyboard insets
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: isDark ? colorScheme.surface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ──────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header ───────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      isBorrowed
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.edit,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isBorrowed ? t.borrowed : t.lent,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Amount — locked ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.background : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount (locked)',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(widget.debt.totalAmount),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Person name ───────────────────────────────────────────
              TextField(
                controller: _nameController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: isBorrowed ? t.borrowedFrom : t.lentTo,
                  prefixIcon: Icon(Icons.person_outline_rounded, color: color),
                  filled: true,
                  fillColor: isDark
                      ? colorScheme.background
                      : Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: color, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Expected return date ──────────────────────────────────
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? colorScheme.background
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: color,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.returnDate,
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(_expectedReturnDate),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Save button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    disabledBackgroundColor: color.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          t.save,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedReturnDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _expectedReturnDate = picked);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AnimatedSnackbar.showError(context, 'Please enter a person name');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updated = DebtModel(
        id: widget.debt.id,
        userId: widget.debt.userId,
        transactionId: widget.debt.transactionId,
        personName: name,
        totalAmount: widget.debt.totalAmount,
        paidAmount: widget.debt.paidAmount,
        debtType: widget.debt.debtType,
        expectedReturnDate: _expectedReturnDate,
        isReturned: widget.debt.isReturned,
        createdAt: widget.debt.createdAt,
        updatedAt: DateTime.now(),
      );

      await DebtLocalDataSourceImpl().updateDebt(updated);

      if (mounted) {
        Navigator.pop(context);
        context.read<HomeBloc>().add(LoadHomeData());
        AnimatedSnackbar.showSuccess(context, 'Debt updated successfully!');
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackbar.showError(context, 'Failed to update: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
