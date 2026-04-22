// ignore_for_file: avoid_print
import 'dart:io';
import 'package:spendio/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spendio/core/utils/currency_formatter.dart';

class AnalyticsPdfService {
  // ── Entry point ───────────────────────────────────────────────────────────
  static Future<void> generateAndShare(
    BuildContext context,
    AnalyticsLoaded state,
  ) async {
    try {
      final file = await _buildPdf(state);
      await _shareFile(context, file);
    } catch (e) {
      print('PDF generation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ── PDF Builder ───────────────────────────────────────────────────────────
  static Future<File> _buildPdf(AnalyticsLoaded state) async {
    final pdf = pw.Document();
    final summary = state.data.summary;
    final period = state.currentPeriod.name.toUpperCase();
    final now = DateFormat('MMM dd, yyyy  |  HH:mm').format(DateTime.now());

    // Colors
    const primaryColor = PdfColor.fromInt(0xFF6C63FF);
    const incomeColor = PdfColor.fromInt(0xFF10b981);
    const expenseColor = PdfColor.fromInt(0xFFef4444);
    const bgColor = PdfColor.fromInt(0xFFF8F9FA);
    const cardColor = PdfColors.white;
    const textDark = PdfColor.fromInt(0xFF1A1A2E);
    const textMuted = PdfColor.fromInt(0xFF6B7280);

    // ── Page 1: Summary ───────────────────────────────────────────────────
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (ctx) => pw.Container(
          color: bgColor,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header gradient bar
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.fromLTRB(32, 36, 32, 28),
                decoration: const pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [primaryColor, PdfColor.fromInt(0xFF8B5CF6)],
                    begin: pw.Alignment.topLeft,
                    end: pw.Alignment.bottomRight,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'ExpenseMate',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.normal,
                                letterSpacing: 2,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Financial Report',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 28,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // ── Period badge — white border, white text ──
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: pw.BoxDecoration(
                            color: const PdfColor.fromInt(0xCC1E1E1E),
                            borderRadius: pw.BorderRadius.circular(20),
                            border: pw.Border.all(
                              color: PdfColors.white,
                              width: 1.5,
                            ),
                          ),
                          child: pw.Text(
                            period,
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Generated $now',
                      style: const pw.TextStyle(
                        color: PdfColor.fromInt(0xCCFFFFFF),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(32, 28, 32, 0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Net balance hero card
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(24),
                      decoration: pw.BoxDecoration(
                        color: cardColor,
                        borderRadius: pw.BorderRadius.circular(16),
                        boxShadow: [
                          pw.BoxShadow(
                            color: PdfColors.grey300,
                            offset: const PdfPoint(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'NET BALANCE',
                            style: pw.TextStyle(
                              color: textMuted,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            '${summary.netBalance >= 0 ? '+' : '-'}${CurrencyFormatter.format(summary.netBalance.abs())}',
                            style: pw.TextStyle(
                              color: summary.netBalance >= 0
                                  ? incomeColor
                                  : expenseColor,
                              fontSize: 36,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 16),
                          pw.Row(
                            children: [
                              _statChip(
                                'Total Income',
                                CurrencyFormatter.format(summary.totalIncome),
                                incomeColor,
                              ),
                              pw.SizedBox(width: 12),
                              _statChip(
                                'Total Expense',
                                CurrencyFormatter.format(summary.totalExpense),
                                expenseColor,
                              ),
                              pw.SizedBox(width: 12),
                              _statChip(
                                'Transactions',
                                '${summary.totalTransactions}',
                                primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 24),

                    // Category Breakdown
                    if (state.data.categoryBreakdown.isNotEmpty) ...[
                      _sectionTitle('Category Breakdown', textDark),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          color: cardColor,
                          borderRadius: pw.BorderRadius.circular(12),
                          boxShadow: [
                            pw.BoxShadow(
                              color: PdfColors.grey300,
                              offset: const PdfPoint(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: pw.Column(
                          children: [
                            // Table header
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: const pw.BoxDecoration(
                                color: PdfColor.fromInt(0xFFF3F4F6),
                                borderRadius: pw.BorderRadius.only(
                                  topLeft: pw.Radius.circular(12),
                                  topRight: pw.Radius.circular(12),
                                ),
                              ),
                              child: pw.Row(
                                children: [
                                  pw.Expanded(
                                    flex: 3,
                                    child: pw.Text(
                                      'Category',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10,
                                        color: textMuted,
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                      'Txns',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10,
                                        color: textMuted,
                                      ),
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(
                                      'Amount',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10,
                                        color: textMuted,
                                      ),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                      'Share',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10,
                                        color: textMuted,
                                      ),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Rows
                            ...state.data.categoryBreakdown
                                .take(10)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (entry) => pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      color: entry.key.isEven
                                          ? cardColor
                                          : const PdfColor.fromInt(0xFFFAFAFA),
                                    ),
                                    child: pw.Row(
                                      children: [
                                        pw.Expanded(
                                          flex: 3,
                                          child: pw.Text(
                                            entry.value.categoryKey,
                                            style: const pw.TextStyle(
                                              fontSize: 11,
                                              color: textDark,
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                            '${entry.value.transactionCount}',
                                            style: const pw.TextStyle(
                                              fontSize: 11,
                                              color: textMuted,
                                            ),
                                            textAlign: pw.TextAlign.center,
                                          ),
                                        ),
                                        pw.Expanded(
                                          flex: 2,
                                          child: pw.Text(
                                            CurrencyFormatter.format(entry.value.amount),
                                            style: pw.TextStyle(
                                              fontSize: 11,
                                              color: textDark,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                            textAlign: pw.TextAlign.right,
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                            '${entry.value.percentage.toStringAsFixed(1)}%',
                                            style: const pw.TextStyle(
                                              fontSize: 11,
                                              color: textMuted,
                                            ),
                                            textAlign: pw.TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // ── Page 2: Trends + Top Transactions ─────────────────────────────────
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (ctx) => pw.Container(
          color: bgColor,
          padding: const pw.EdgeInsets.fromLTRB(32, 32, 32, 32),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Page header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle('Monthly Trends', textDark),
                  pw.Text(
                    'ExpenseMate Report',
                    style: const pw.TextStyle(fontSize: 9, color: textMuted),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              // Monthly trends table
              if (state.data.monthlyTrends.isNotEmpty)
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: cardColor,
                    borderRadius: pw.BorderRadius.circular(12),
                    boxShadow: [
                      pw.BoxShadow(
                        color: PdfColors.grey300,
                        offset: const PdfPoint(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFF3F4F6),
                          borderRadius: pw.BorderRadius.only(
                            topLeft: pw.Radius.circular(12),
                            topRight: pw.Radius.circular(12),
                          ),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Month',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textMuted,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Income',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: incomeColor,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Expense',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: expenseColor,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Net',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textMuted,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...state.data.monthlyTrends.asMap().entries.map((entry) {
                        final net = entry.value.income - entry.value.expense;
                        return pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: pw.BoxDecoration(
                            color: entry.key.isEven
                                ? cardColor
                                : const PdfColor.fromInt(0xFFFAFAFA),
                          ),
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  entry.value.month,
                                  style: const pw.TextStyle(
                                    fontSize: 11,
                                    color: textDark,
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  CurrencyFormatter.format(entry.value.income),
                                  style: const pw.TextStyle(
                                    fontSize: 11,
                                    color: incomeColor,
                                  ),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  CurrencyFormatter.format(entry.value.expense),
                                  style: const pw.TextStyle(
                                    fontSize: 11,
                                    color: expenseColor,
                                  ),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  '${net >= 0 ? '+' : '-'}${CurrencyFormatter.format(net.abs())}',
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    color: net >= 0
                                        ? incomeColor
                                        : expenseColor,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              pw.SizedBox(height: 24),

              // Top transactions
              if (state.data.topTransactions.isNotEmpty) ...[
                _sectionTitle('Top Transactions', textDark),
                pw.SizedBox(height: 12),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: cardColor,
                    borderRadius: pw.BorderRadius.circular(12),
                    boxShadow: [
                      pw.BoxShadow(
                        color: PdfColors.grey300,
                        offset: const PdfPoint(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFFF3F4F6),
                          borderRadius: pw.BorderRadius.only(
                            topLeft: pw.Radius.circular(12),
                            topRight: pw.Radius.circular(12),
                          ),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                'Category',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textMuted,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Date',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textMuted,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Amount',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                  color: textMuted,
                                ),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...state.data.topTransactions
                          .take(10)
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (entry) => pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: pw.BoxDecoration(
                                color: entry.key.isEven
                                    ? cardColor
                                    : const PdfColor.fromInt(0xFFFAFAFA),
                              ),
                              child: pw.Row(
                                children: [
                                  pw.Expanded(
                                    flex: 3,
                                    child: pw.Text(
                                      entry.value.categoryKey,
                                      style: const pw.TextStyle(
                                        fontSize: 11,
                                        color: textDark,
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(
                                      DateFormat(
                                        'MMM dd',
                                      ).format(entry.value.date),
                                      style: const pw.TextStyle(
                                        fontSize: 11,
                                        color: textMuted,
                                      ),
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(
                                      CurrencyFormatter.format(entry.value.amount),
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        color: entry.value.isIncome
                                            ? incomeColor
                                            : expenseColor,
                                      ),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],

              pw.Spacer(),

              // Footer
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'ExpenseMate • Financial Report',
                    style: const pw.TextStyle(fontSize: 9, color: textMuted),
                  ),
                  pw.Text(
                    now,
                    style: const pw.TextStyle(fontSize: 9, color: textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // ── Save to temp dir (no permissions needed) ──────────────────────────
    final dir = await getTemporaryDirectory();
    final fileName =
        'ExpenseMate_Report_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ── Share via system share sheet (WhatsApp, Drive, etc.) ─────────────────
  static Future<void> _shareFile(BuildContext context, File file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'ExpenseMate Financial Report',
        text: 'My financial report from ExpenseMate',
      ),
    );
  }

  // ── Helper widgets ────────────────────────────────────────────────────────
  static pw.Widget _sectionTitle(String title, PdfColor color) => pw.Text(
    title,
    style: pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: color,
    ),
  );

  static pw.Widget _statChip(String label, String value, PdfColor color) =>
      pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                label,
                style: pw.TextStyle(
                  fontSize: 9,
                  color: const PdfColor.fromInt(0xCCFFFFFF),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
      );
}
