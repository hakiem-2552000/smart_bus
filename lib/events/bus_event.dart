import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BusEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BusEventRequest extends BusEvent {}

class BusEventUpdateStop extends BusEvent {
  final int position;
  BusEventUpdateStop({@required this.position});
}
