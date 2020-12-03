import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ActiveState extends Equatable {
  const ActiveState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ActiveStateInitial extends ActiveState {}

class ActiveStateLoading extends ActiveState {}

class ActiveStateCheckInSuccess extends ActiveState {}

class ActiveStateCheckInFailure extends ActiveState {}

class ActiveStateCheckOutSuccess extends ActiveState {}

class ActiveStateCheckOutFailure extends ActiveState {}
