import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CurrentEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CurrentEventRequest extends CurrentEvent {}
