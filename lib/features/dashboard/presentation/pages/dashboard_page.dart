import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/app/routes/app_routes.dart';
import 'package:vision_vault_mobile/features/dashboard/data/repositories/websocket_analytics_repository.dart';
import 'package:vision_vault_mobile/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:vision_vault_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/widgets/feature_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(WebsocketAnalyticsRepository())
        ..connectToLiveMetrics(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  Future<void> _pickDateRange() async {
    unawaited(HapticFeedback.lightImpact());
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.secondary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // _selectedDateRange = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Analytics'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            onPressed: _pickDateRange,
          ),
          const IconButton(
            icon: Icon(Icons.settings),
            onPressed: HapticFeedback.lightImpact,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  var activeScanners = 0;
                  double successRate = 0;

                  if (state is DashboardLive) {
                    activeScanners = state.activeScanners;
                    successRate = state.successRate;
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildMetricCard(
                        context,
                        'Active Scanners',
                        state is DashboardLoading ? '...' : '$activeScanners',
                        Icons.scanner_outlined,
                        Colors.blue,
                      ),
                      _buildMetricCard(
                        context,
                        'Success Rate',
                        state is DashboardLoading
                            ? '...'
                            : '${successRate.toStringAsFixed(1)}%',
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                      _buildMetricCard(
                        context,
                        'Plates Read',
                        '1,284',
                        Icons.directions_car_outlined,
                        Colors.orange,
                      ),
                      _buildMetricCard(
                        context,
                        'QR Generated',
                        '8,492',
                        Icons.qr_code_2_outlined,
                        Colors.purple,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Processing Success Trend',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 250,
                child: _buildLineChart(theme),
              ),
              const SizedBox(height: 40),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              FeatureCard(
                title: 'New QR Code',
                description: 'Generate standard and secure QR structures.',
                icon: Icons.qr_code_scanner,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.qrGenerator),
              ),
              const SizedBox(height: 12),
              FeatureCard(
                title: 'Scan Plate (OCR)',
                description: 'Utilize ML Kit for rapid plate recognition.',
                icon: Icons.camera_alt_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.plateReader),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(ThemeData theme) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
          leftTitles: AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 3.5),
              FlSpot(2, 4.5),
              FlSpot(3, 4),
              FlSpot(4, 5.2),
              FlSpot(5, 5),
              FlSpot(6, 5.8),
            ],
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
