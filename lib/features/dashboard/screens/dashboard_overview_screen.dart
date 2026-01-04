import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/features/dashboard/providers/dashboard_bloc.dart';
import 'package:intl/intl.dart';

class DashboardOverviewScreen extends StatelessWidget {
  final Function(int) onAction;
  const DashboardOverviewScreen({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<DashboardBloc>().add(LoadDashboardStats()),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            final stats = state.stats;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 1200
                          ? 4
                          : (constraints.maxWidth > 800 ? 2 : 1);
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.5,
                        children: [
                          _StatCard(
                            title: 'Total Sales',
                            value: '\$${stats.totalSales.toStringAsFixed(2)}',
                            icon: Icons.attach_money,
                            color: Colors.green,
                          ),
                          _StatCard(
                            title: 'Total Profit',
                            value: '\$${stats.totalProfit.toStringAsFixed(2)}',
                            icon: Icons.trending_up,
                            color: Colors.blue,
                          ),
                          _StatCard(
                            title: 'Low Stock Items',
                            value: stats.lowStockCount.toString(),
                            icon: Icons.warning_amber_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          _StatCard(
                            title: 'Total Products',
                            value: stats.totalProducts.toString(),
                            icon: Icons.inventory_2,
                            color: Colors.purple,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recent Sales Table
                      Expanded(
                        flex: 2,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Recent Sales',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                if (stats.recentSales.isEmpty)
                                  const Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(32),
                                          child: Text('No sales yet.')))
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: stats.recentSales.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) {
                                      final sale = stats.recentSales[index];
                                      return ListTile(
                                        title: Text(sale.saleNumber),
                                        subtitle: Text(
                                            DateFormat('dd MMM yyyy HH:mm')
                                                .format(sale.saleDate)),
                                        trailing: Text(
                                            '\$${sale.totalAmount.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Quick Actions
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Quick Actions',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                _QuickActionButton(
                                  label: 'POS',
                                  icon: Icons.sell,
                                  onPressed: () => onAction(6),
                                ),
                                const SizedBox(height: 8),
                                _QuickActionButton(
                                  label: 'Add Product',
                                  icon: Icons.add_box,
                                  onPressed: () => onAction(1),
                                ),
                                const SizedBox(height: 8),
                                _QuickActionButton(
                                  label: 'Stock In',
                                  icon: Icons.shopping_cart,
                                  onPressed: () => onAction(5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
