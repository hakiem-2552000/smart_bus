import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bus/models/bank_model.dart';

abstract class BankState extends Equatable {
  const BankState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BankStateInitial extends BankState {}

class BankStateLoading extends BankState {}

class BankStateGetSuccess extends BankState {
  final Bank bank;
  BankStateGetSuccess({this.bank});
}
