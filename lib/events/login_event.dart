import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEventEmailChange extends LoginEvent {
  final String email;
  LoginEventEmailChange({@required this.email});
  @override
  List<Object> get props => [email];
}

class LoginEventPasswordChange extends LoginEvent {
  final String password;
  LoginEventPasswordChange({@required this.password});
  @override
  List<Object> get props => [password];
}

class LoginEventPressed extends LoginEvent {
  final String email;
  final String password;
  LoginEventPressed({@required this.email, @required this.password});
  @override
  List<Object> get props => [email, password];
}
