import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HistoryEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HistoryEventRequest extends HistoryEvent {}
