import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateSuccess extends AuthenticationState {}

class AuthenticationStateFailure extends AuthenticationState {}

class AuthenticationStateRegisterUser extends AuthenticationState {
  final String email;
  AuthenticationStateRegisterUser({this.email});
}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationStateLoggedOut extends AuthenticationState {}

class AuthenticationStateIsDriver extends AuthenticationState {}
