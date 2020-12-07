import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DashboardEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DashboardEventRequest extends DashboardEvent {}
