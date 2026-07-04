import 'package:equatable/equatable.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLive extends DashboardState {

  const DashboardLive({
    required this.activeScanners,
    required this.successRate,
  });
  final int activeScanners;
  final double successRate;

  @override
  List<Object> get props => [activeScanners, successRate];
}

final class DashboardError extends DashboardState {

  const DashboardError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
