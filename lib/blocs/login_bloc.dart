import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/login_event.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/login_state.dart';
import 'package:smart_bus/validators/validators.dart';

@immutable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;
  LoginBloc({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    if (loginEvent is LoginEventStarted) {
      yield LoginState.initial();
    } else if (loginEvent is LoginEventEmailChange) {
      yield state.cloneAndUpdate(
        isValidEmail: Validators.isValidEmail(loginEvent.email),
      );
    }
    if (loginEvent is LoginEventPasswordChange) {
      yield state.cloneAndUpdate(
        isValidPassword: Validators.isValidPassword(loginEvent.password),
      );
    }
    if (loginEvent is LoginEventPressed) {
      yield LoginState.loading();
      try {
        await _userRepository.signInWithEmailAndPassword(
          email: loginEvent.email,
          password: loginEvent.password,
        );
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
