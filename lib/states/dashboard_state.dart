import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bus/models/bank_model.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/models/trip_history_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DashboardStateInitial extends DashboardState {}

class DashboardStateLoading extends DashboardState {}

class DashboardStateSuccess extends DashboardState {
  final bool isOnBus;
  final TripHistory tripHistory;
  final Bus bus;

  DashboardStateSuccess({this.isOnBus, this.tripHistory, this.bus});
}

class DashboardStateFailure extends DashboardState {}
