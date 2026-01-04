import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';
import 'package:inventory_system/features/sales/providers/sale_bloc.dart';
import 'package:inventory_system/features/purchases/providers/purchase_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'dart:html' as html;

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Exports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _ReportCard(
                  title: 'Inventory Report',
                  description:
                      'Current stock levels, pricing, and low stock alerts.',
                  icon: Icons.inventory_2,
                  onPdf: () => _generateInventoryPdf(context),
                  onExcel: () => _generateInventoryExcel(context),
                ),
                _ReportCard(
                  title: 'Sales Report',
                  description: 'History of all sales with profit calculations.',
                  icon: Icons.sell,
                  onPdf: () => _generateSalesPdf(context),
                  onExcel: () => _generateSalesExcel(context),
                ),
                _ReportCard(
                  title: 'Purchase Report',
                  description: 'History of all stock-in transactions.',
                  icon: Icons.shopping_cart,
                  onPdf: () => _generatePurchasesPdf(context),
                  onExcel: () => _generatePurchasesExcel(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Inventory Report ---
  Future<void> _generateInventoryPdf(BuildContext context) async {
    final state = context.read<ProductBloc>().state;
    if (state is! ProductsLoaded) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Inventory Stock Report')),
          pw.TableHelper.fromTextArray(
            headers: ['SKU', 'Product Name', 'Quantity', 'Price'],
            data: state.products
                .map((p) => [
                      p.sku,
                      p.name,
                      p.quantity.toString(),
                      '\$${p.sellingPrice.toStringAsFixed(2)}'
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _generateInventoryExcel(BuildContext context) async {
    final state = context.read<ProductBloc>().state;
    if (state is! ProductsLoaded) return;

    var excel = Excel.createExcel();
    Sheet sheet = excel['Inventory'];
    sheet.appendRow([
      TextCellValue('SKU'),
      TextCellValue('Product Name'),
      TextCellValue('Quantity'),
      TextCellValue('Price')
    ]);

    for (var p in state.products) {
      sheet.appendRow([
        TextCellValue(p.sku),
        TextCellValue(p.name),
        IntCellValue(p.quantity),
        DoubleCellValue(p.sellingPrice),
      ]);
    }

    _downloadFile(excel.save()!, 'inventory_report.xlsx');
  }

  void _downloadFile(List<int> bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // --- Sales Report ---
  Future<void> _generateSalesPdf(BuildContext context) async {
    final state = context.read<SaleBloc>().state;
    if (state is! SalesLoaded) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Sales Report')),
          pw.TableHelper.fromTextArray(
            headers: ['Sale #', 'Customer', 'Date', 'Amount', 'Profit'],
            data: state.sales
                .map((s) => [
                      s.saleNumber,
                      s.customerName,
                      s.saleDate.toString().split('.')[0],
                      '\$${s.totalAmount.toStringAsFixed(2)}',
                      '\$${s.totalProfit.toStringAsFixed(2)}'
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _generateSalesExcel(BuildContext context) async {
    final state = context.read<SaleBloc>().state;
    if (state is! SalesLoaded) return;

    var excel = Excel.createExcel();
    Sheet sheet = excel['Sales'];
    sheet.appendRow([
      TextCellValue('Sale #'),
      TextCellValue('Customer'),
      TextCellValue('Date'),
      TextCellValue('Amount'),
      TextCellValue('Profit')
    ]);

    for (var s in state.sales) {
      sheet.appendRow([
        TextCellValue(s.saleNumber),
        TextCellValue(s.customerName ?? 'N/A'),
        TextCellValue(s.saleDate.toString().split('.')[0]),
        DoubleCellValue(s.totalAmount),
        DoubleCellValue(s.totalProfit),
      ]);
    }

    _downloadFile(excel.save()!, 'sales_report.xlsx');
  }

  // --- Purchase Report ---
  Future<void> _generatePurchasesPdf(BuildContext context) async {
    final state = context.read<PurchaseBloc>().state;
    if (state is! PurchasesLoaded) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Purchase Report')),
          pw.TableHelper.fromTextArray(
            headers: ['Purchase #', 'Date', 'Total Amount'],
            data: state.purchases
                .map((p) => [
                      p.purchaseNumber,
                      p.purchaseDate.toString().split('.')[0],
                      '\$${p.totalAmount.toStringAsFixed(2)}'
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _generatePurchasesExcel(BuildContext context) async {
    final state = context.read<PurchaseBloc>().state;
    if (state is! PurchasesLoaded) return;

    var excel = Excel.createExcel();
    Sheet sheet = excel['Purchases'];
    sheet.appendRow([
      TextCellValue('Purchase #'),
      TextCellValue('Date'),
      TextCellValue('Total Amount')
    ]);

    for (var p in state.purchases) {
      sheet.appendRow([
        TextCellValue(p.purchaseNumber),
        TextCellValue(p.purchaseDate.toString().split('.')[0]),
        DoubleCellValue(p.totalAmount),
      ]);
    }

    _downloadFile(excel.save()!, 'purchases_report.xlsx');
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onPdf;
  final VoidCallback onExcel;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onPdf,
    required this.onExcel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,
                  size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDF'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onExcel,
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Excel'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[50],
                          foregroundColor: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
