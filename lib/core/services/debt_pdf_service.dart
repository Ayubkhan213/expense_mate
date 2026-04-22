import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/utils/currency_formatter.dart';

class DebtPdfService {
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
    required DebtModel debt,
    required List<DebtPaymentModel> payments,
  }) async {
    final pdf = await _buildPdf(debt, payments);
    final fileName =
        'debt_${debt.personName.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';

    await Printing.sharePdf(bytes: pdf, filename: fileName);
  }

  // ── Build the full PDF ───────────────────────────────────────────────────
  static Future<Uint8List> _buildPdf(
    DebtModel debt,
    List<DebtPaymentModel> payments,
  ) async {
    final pdf = pw.Document(
      title: 'Debt Report — ${debt.personName}',
      author: 'Spendio',
    );

    // Compute stats
    final totalAmount = debt.totalAmount;
    final totalPaid = payments.fold<double>(0.0, (sum, p) => sum + p.amount);
    final remaining = totalAmount - totalPaid;
    final progress = totalAmount > 0 ? (totalPaid / totalAmount).clamp(0.0, 1.0) : 0.0;
    final isPaidOff = remaining <= 0;
    
    final progressColor = isPaidOff
        ? _green
        : progress > 0.8
            ? _amber
            : _primary;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => [
          _buildHeader(debt),
          pw.SizedBox(height: 20),
          _buildSummaryCards(
            totalAmount,
            totalPaid,
            remaining,
            isPaidOff,
            progressColor,
          ),
          pw.SizedBox(height: 16),
          _buildProgressBar(progress, progressColor, isPaidOff),
          pw.SizedBox(height: 20),
          _buildInfoRow(debt),
          pw.SizedBox(height: 20),
          _buildSectionTitle(
            'Repayment History (${payments.length} records)',
          ),
          pw.SizedBox(height: 10),
          if (payments.isEmpty)
            _buildEmptyState()
          else
            _buildPaymentTable(payments),
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  // ── Header ───────────────────────────────────────────────────────────────
  static pw.Widget _buildHeader(DebtModel debt) {
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
                'Debt Report',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                debt.personName,
                style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold),
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
              debt.debtType.name.toUpperCase(),
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
    double total,
    double paid,
    double remaining,
    bool isPaidOff,
    PdfColor progressColor,
  ) {
    return pw.Row(
      children: [
        _summaryCard(
          'Total Amount',
          CurrencyFormatter.format(total),
          _primary,
        ),
        pw.SizedBox(width: 10),
        _summaryCard(
          'Total Paid',
          CurrencyFormatter.format(paid),
          _green,
        ),
        pw.SizedBox(width: 10),
        _summaryCard(
          isPaidOff ? 'Status' : 'Remaining',
          isPaidOff ? 'FULLY PAID' : CurrencyFormatter.format(remaining.abs()),
          progressColor,
        ),
      ],
    );
  }

  static pw.Widget _summaryCard(
    String label,
    String value,
    PdfColor color,
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
                fontSize: 15,
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
    bool isPaidOff,
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
                'Repayment Progress',
                style: pw.TextStyle(
                  color: _textDark,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                isPaidOff ? 'Completed' : '$pct% paid',
                style: pw.TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.LayoutBuilder(
            builder: (ctx, constraints) {
              final totalWidth = constraints!.maxWidth;
              final filledWidth = totalWidth * clampedProgress;
              return pw.Stack(
                children: [
                  pw.Container(
                    width: totalWidth,
                    height: 10,
                    decoration: pw.BoxDecoration(
                      color: _bg,
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                  ),
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
  static pw.Widget _buildInfoRow(DebtModel debt) {
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
            'Created On',
            DateFormat('dd MMM yyyy').format(debt.createdAt),
          ),
          _divider(),
          _infoItem(
            'Due Date',
            DateFormat('dd MMM yyyy').format(debt.expectedReturnDate),
          ),
          _divider(),
          _infoItem('Person', debt.personName),
          if (debt.personPhone != null) ...[
            _divider(),
            _infoItem('Phone', debt.personPhone!),
          ],
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

  // ── Payment table ────────────────────────────────────────────────────────
  static pw.Widget _buildPaymentTable(List<DebtPaymentModel> payments) {
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
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Method',
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    'Note',
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    'Amount',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...payments.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final isEven = i % 2 == 0;

            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              color: isEven ? _surface : _bg,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      DateFormat('dd MMM yy').format(p.paymentDate),
                      style: pw.TextStyle(color: _textLight, fontSize: 9),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      p.paymentMethod.name.toUpperCase(),
                      style: pw.TextStyle(color: _textDark, fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      p.note?.isEmpty ?? true ? '—' : p.note!,
                      style: pw.TextStyle(color: _textLight, fontSize: 9),
                      maxLines: 2,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      CurrencyFormatter.format(p.amount),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: _green,
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
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  'Total Repayments (${payments.length})',
                  style: pw.TextStyle(color: _textDark, fontSize: 11, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  CurrencyFormatter.format(payments.fold(0.0, (s, p) => s + p.amount)),
                  style: pw.TextStyle(color: _primary, fontSize: 13, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  static pw.Widget _buildEmptyState() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Center(
        child: pw.Text('No repayment records found.', style: pw.TextStyle(color: _textLight, fontSize: 12)),
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(width: 4, height: 18, color: _primary, margin: const pw.EdgeInsets.only(right: 8)),
        pw.Text(title, style: pw.TextStyle(color: _textDark, fontSize: 13, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: _border))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Generated by Spendio', style: pw.TextStyle(color: _textLight, fontSize: 9)),
          pw.Text(DateFormat('dd MMM yyyy').format(DateTime.now()), style: pw.TextStyle(color: _textLight, fontSize: 9)),
        ],
      ),
    );
  }

  static String _fmt(double amount) {
    if (amount >= 1000) {
      return amount.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(2);
  }
}
