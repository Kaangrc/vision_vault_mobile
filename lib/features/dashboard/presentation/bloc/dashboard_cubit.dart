import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/features/dashboard/domain/repositories/analytics_repository.dart';
import 'package:vision_vault_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardInitial());
  final AnalyticsRepository _repository;
  StreamSubscription<Map<String, dynamic>>? _metricsSubscription;

  void connectToLiveMetrics() {
    emit(const DashboardLoading());
    _repository.connect();

    _metricsSubscription = _repository.liveMetrics.listen(
      (data) {
        if (data['type'] == 'metrics_update') {
          emit(
            DashboardLive(
              activeScanners: data['active_scanners'] as int,
              successRate: (data['success_rate'] as num).toDouble(),
            ),
          );
        }
      },
      onError: (Object error) {
        emit(DashboardError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _metricsSubscription?.cancel();
    _repository.disconnect();
    return super.close();
  }
}
