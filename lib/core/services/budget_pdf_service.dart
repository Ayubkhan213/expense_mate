import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:spendio/core/data/models/budget_model.dart';

import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/utils/currency_formatter.dart';

class BudgetPdfService {
  // ── Color palette ────────────────────────────────────────────────────────
  static const _primary = PdfColor.fromInt(0xFF1565C0);
  static const _green = PdfColor.fromInt(0xFF10b981);
  static const _red = PdfColor.fromInt(0xFFef4444);
  static const _amber = PdfColor.fromInt(0xFFf59e0b);
  static const _bg = PdfColor.fromInt(0xFFF2F4F8);
  static const _surface = PdfColor.fromInt(0xFFFFFFFF);
  static const _textDark = PdfColor.fromInt(0xFF1A1A2E);
  static const _textLight = PdfColor.fromInt(0xFF6B7280);
  static const _border = PdfColor.fromInt(0xFFE5E7EB);

  // ── Main entry point ─────────────────────────────────────────────────────
  static Future<void> exportAndShare({
    required BuildContext context,
    required BudgetModel budget,
    required List<TransactionModel> transactions,
  }) async {
    final pdf = await _buildPdf(budget, transactions);
    final fileName =
        'budget_${budget.name.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';

    await Printing.sharePdf(bytes: pdf, filename: fileName);
  }

  // ── Build the full PDF ───────────────────────────────────────────────────
  static Future<Uint8List> _buildPdf(
    BudgetModel budget,
    List<TransactionModel> transactions,
  ) async {
    final pdf = pw.Document(
      title: 'Budget Report — ${budget.name}',
      author: 'Spendio',
    );

    // Compute stats
    final totalSpent = budget.spentAmount;
    final remaining = budget.remainingAmount;
    final progress = budget.spentPercentage / 100;
    final isOver = budget.isOverBudget;
    final progressColor = isOver
        ? _red
        : progress > 0.8
        ? _amber
        : _green;

    // Group transactions by date
    final byDate = <String, List<TransactionModel>>{};
    for (final t in transactions) {
      final key = DateFormat('dd MMM yyyy').format(t.date);
      byDate.putIfAbsent(key, () => []).add(t);
    }

    // Payment method breakdown
    final methodTotals = <String, double>{};
    final methodCounts = <String, int>{};
    for (final t in transactions) {
      final m = t.paymentMethod.name;
      methodTotals[m] = (methodTotals[m] ?? 0) + t.totalAmount;
      methodCounts[m] = (methodCounts[m] ?? 0) + 1;
    }

    // Category breakdown
    final catTotals = <String, double>{};
    for (final t in transactions) {
      for (final item in t.items) {
        catTotals[item.category] =
            (catTotals[item.category] ?? 0) + item.amount;
      }
    }
    final sortedCats = catTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => [
          _buildHeader(budget),
          pw.SizedBox(height: 20),
          _buildSummaryCards(
            budget,
            totalSpent,
            remaining,
            isOver,
            progressColor,
          ),
          pw.SizedBox(height: 16),
          _buildProgressBar(progress, progressColor, budget),
          pw.SizedBox(height: 20),
          _buildInfoRow(budget),
          pw.SizedBox(height: 20),
          if (sortedCats.isNotEmpty) ...[
            _buildSectionTitle('Category Breakdown'),
            pw.SizedBox(height: 10),
            _buildCategoryBreakdown(sortedCats, totalSpent),
            pw.SizedBox(height: 20),
          ],
          if (methodTotals.isNotEmpty) ...[
            _buildSectionTitle('Payment Method Summary'),
            pw.SizedBox(height: 10),
            _buildPaymentMethodTable(methodTotals, methodCounts),
            pw.SizedBox(height: 20),
          ],
          _buildSectionTitle(
            'Transaction History (${transactions.length} records)',
          ),
          pw.SizedBox(height: 10),
          if (transactions.isEmpty)
            _buildEmptyTransactions()
          else
            _buildTransactionTable(transactions),
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  // ── Header ───────────────────────────────────────────────────────────────
  static pw.Widget _buildHeader(BudgetModel budget) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _primary,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Budget Report',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                budget.name,
                style: pw.TextStyle(color: PdfColors.white, fontSize: 14),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Generated ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(color: PdfColors.white, fontSize: 10),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(20),
            ),
            child: pw.Text(
              budget.type.name.toUpperCase(),
              style: pw.TextStyle(
                color: _primary,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary cards ────────────────────────────────────────────────────────
  static pw.Widget _buildSummaryCards(
    BudgetModel budget,
    double totalSpent,
    double remaining,
    bool isOver,
    PdfColor progressColor,
  ) {
    return pw.Row(
      children: [
        _summaryCard(
          'Total Budget',
          CurrencyFormatter.format(budget.totalAmount),
          _primary,
          Icons.account_balance_wallet,
        ),
        pw.SizedBox(width: 10),
        _summaryCard(
          'Total Spent',
          CurrencyFormatter.format(totalSpent),
          _red,
          Icons.arrow_upward,
        ),
        pw.SizedBox(width: 10),
        _summaryCard(
          isOver ? 'Over Budget' : 'Remaining',
          CurrencyFormatter.format(remaining.abs()),
          progressColor,
          isOver ? Icons.warning : Icons.savings,
        ),
      ],
    );
  }

  static pw.Widget _summaryCard(
    String label,
    String value,
    PdfColor color,
    IconData icon,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(
          color: _surface,
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: _border),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                color: _textLight,
                fontSize: 10,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              value,
              style: pw.TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Progress bar ─────────────────────────────────────────────────────────
  static pw.Widget _buildProgressBar(
    double progress,
    PdfColor color,
    BudgetModel budget,
  ) {
    final pct = (progress * 100).clamp(0, 100).toStringAsFixed(1);
    final clampedProgress = progress.clamp(0.0, 1.0);

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Budget Utilization',
                style: pw.TextStyle(
                  color: _textDark,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '$pct% used',
                style: pw.TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          // ✅ Use LayoutBuilder to get width then draw bar manually
          pw.LayoutBuilder(
            builder: (ctx, constraints) {
              final totalWidth = constraints!.maxWidth;
              final filledWidth = totalWidth * clampedProgress;
              return pw.Stack(
                children: [
                  // Background track
                  pw.Container(
                    width: totalWidth,
                    height: 10,
                    decoration: pw.BoxDecoration(
                      color: _bg,
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                  ),
                  // Filled portion
                  pw.Container(
                    width: filledWidth,
                    height: 10,
                    decoration: pw.BoxDecoration(
                      color: color,
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Info row ─────────────────────────────────────────────────────────────
  static pw.Widget _buildInfoRow(BudgetModel budget) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _infoItem(
            'Start Date',
            DateFormat('dd MMM yyyy').format(budget.startDate),
          ),
          _divider(),
          _infoItem(
            'End Date',
            DateFormat('dd MMM yyyy').format(budget.endDate),
          ),
          _divider(),
          _infoItem('Duration', '${budget.daysRemaining} days left'),
          _divider(),
          _infoItem('Status', budget.isExpired ? 'Expired' : 'Active'),
        ],
      ),
    );
  }

  static pw.Widget _infoItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(color: _textLight, fontSize: 9)),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: _textDark,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _divider() {
    return pw.Container(width: 1, height: 30, color: _border);
  }

  // ── Category breakdown ───────────────────────────────────────────────────
  static pw.Widget _buildCategoryBreakdown(
    List<MapEntry<String, double>> cats,
    double total,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        children: [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: _bg,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Category',
                    style: pw.TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    'Amount',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    '%',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...cats.asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value;
            final pct = total > 0 ? (cat.value / total * 100) : 0;
            final isEven = i % 2 == 0;
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              color: isEven ? _surface : _bg,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      cat.key,
                      style: pw.TextStyle(color: _textDark, fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      CurrencyFormatter.format(cat.value),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: _textDark,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      '${pct.toStringAsFixed(1)}%',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(color: _primary, fontSize: 10),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Payment method table ─────────────────────────────────────────────────
  static pw.Widget _buildPaymentMethodTable(
    Map<String, double> amounts,
    Map<String, int> counts,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: _bg,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Method',
                    style: pw.TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    'Transactions',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    'Total',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...amounts.entries.toList().asMap().entries.map((entry) {
            final i = entry.key;
            final method = entry.value;
            final isEven = i % 2 == 0;
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              color: isEven ? _surface : _bg,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      method.key.toUpperCase(),
                      style: pw.TextStyle(
                        color: _textDark,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      '${counts[method.key] ?? 0}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(color: _textLight, fontSize: 10),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      CurrencyFormatter.format(method.value),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: _textDark,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Transaction table ────────────────────────────────────────────────────
  static pw.Widget _buildTransactionTable(List<TransactionModel> transactions) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        children: [
          // Table header
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: _primary,
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Date',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Category',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Method',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Note',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Amount',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...transactions.asMap().entries.map((entry) {
            final i = entry.key;
            final txn = entry.value;
            final isEven = i % 2 == 0;
            final firstItem = txn.items.isNotEmpty ? txn.items.first : null;
            final note = firstItem?.note ?? '';
            final category = firstItem?.category ?? '';

            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              color: isEven ? _surface : _bg,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      DateFormat('dd MMM yy').format(txn.date),
                      style: pw.TextStyle(color: _textLight, fontSize: 9),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      category,
                      style: pw.TextStyle(
                        color: _textDark,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      txn.paymentMethod.name.toUpperCase(),
                      style: pw.TextStyle(color: _textLight, fontSize: 9),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      note.isEmpty ? '—' : note,
                      style: pw.TextStyle(color: _textLight, fontSize: 9),
                      maxLines: 2,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      CurrencyFormatter.format(txn.totalAmount),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: _red,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // Total row
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: pw.BoxDecoration(
              color: _bg,
              borderRadius: const pw.BorderRadius.only(
                bottomLeft: pw.Radius.circular(10),
                bottomRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total (${transactions.length} transactions)',
                  style: pw.TextStyle(
                    color: _textDark,
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  CurrencyFormatter.format(transactions.fold(0.0, (s, t) => s + t.totalAmount)),
                  style: pw.TextStyle(
                    color: _primary,
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────
  static pw.Widget _buildEmptyTransactions() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Center(
        child: pw.Text(
          'No transactions recorded yet.',
          style: pw.TextStyle(color: _textLight, fontSize: 12),
        ),
      ),
    );
  }

  // ── Section title ────────────────────────────────────────────────────────
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 18,
          color: _primary,
          margin: const pw.EdgeInsets.only(right: 8),
        ),
        pw.Text(
          title,
          style: pw.TextStyle(
            color: _textDark,
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── Footer ───────────────────────────────────────────────────────────────
  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _border)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by Spendio',
            style: pw.TextStyle(color: _textLight, fontSize: 9),
          ),
          pw.Text(
            DateFormat('dd MMM yyyy').format(DateTime.now()),
            style: pw.TextStyle(color: _textLight, fontSize: 9),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  static String _fmt(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(2);
  }
}
