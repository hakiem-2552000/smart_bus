import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BankEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BankEventGetInfo extends BankEvent {}

class BankEventRechargeCoin extends BankEvent {
  final String amount;
  BankEventRechargeCoin({@required this.amount});
  @override
  List<Object> get props => [amount];
}
