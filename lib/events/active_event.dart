import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_bus/models/trip_history_model.dart';

abstract class ActiveEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ActiveEventCheckIn extends ActiveEvent {
  final TripHistory tripHistory;

  ActiveEventCheckIn({this.tripHistory});
}

class ActiveEventCheckOut extends ActiveEvent {
  final TripHistory tripHistory;

  ActiveEventCheckOut({this.tripHistory});
}
