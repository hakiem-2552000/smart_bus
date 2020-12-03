import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CustomerEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CustomerEventGetByCode extends CustomerEvent {
  final String code;
  CustomerEventGetByCode({this.code});
}

class CustomerEventCheckIn extends CustomerEvent {
  final String uid;
  CustomerEventCheckIn({this.uid});
}

class CustomerEventCheckOut extends CustomerEvent {
  final String uid;
  CustomerEventCheckOut({this.uid});
}
