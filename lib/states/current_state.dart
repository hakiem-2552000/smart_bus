import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bus/models/bank_model.dart';

abstract class CurrentState extends Equatable {
  const CurrentState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CurrentStateInitial extends CurrentState {}

class CurrentStateLoading extends CurrentState {}

class CurrentStateSuccess extends CurrentState {
  final int cost;
  CurrentStateSuccess({this.cost});
}

class CurrentStateFailure extends CurrentState {}
