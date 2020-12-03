import 'package:equatable/equatable.dart';
import 'package:smart_bus/models/bus_model.dart';

abstract class BusState extends Equatable {
  const BusState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BusStateInitial extends BusState {}

class BusStateLoading extends BusState {}

class BusStateSuccess extends BusState {
  final Bus bus;
  BusStateSuccess({this.bus});
}

class BusStateFailure extends BusState {}
