import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthenticationEventStarted extends AuthenticationEvent {}

class AuthenticationEventLoggedIn extends AuthenticationEvent {
  final String email;
  AuthenticationEventLoggedIn({@required this.email});
  @override
  List<Object> get props => [email];
}

class AuthenticationEventLoggedOut extends AuthenticationEvent {}
