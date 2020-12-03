import 'package:equatable/equatable.dart';
import 'package:smart_bus/models/customer_model.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CustomerStateInittial extends CustomerState {}

class CustomerStateLoading extends CustomerState {}

class CustomerStateGetSuccess extends CustomerState {
  final Customer customer;
  CustomerStateGetSuccess({this.customer});
}

class CustomerStateFailure extends CustomerState {}

class CustomerStateCheckInSuccess extends CustomerState {}

class CustomerStateCheckInFailure extends CustomerState {}

class CustomerStateCheckOutSuccess extends CustomerState {}

class CustomerStateCheckOutFailure extends CustomerState {}
