import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_bus/events/auth_event.dart';
import 'package:smart_bus/main.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  //constructor
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationStateInitial()); //initial state

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent authenticationEvent) async* {
    if (authenticationEvent is AuthenticationEventStarted) {
      yield AuthenticationStateInitial();
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      yield AuthenticationLoading();
      bool _isExist = false;
      await _userRepository
          .isExistedUser(email: authenticationEvent.email)
          .then((value) {
        _isExist = value;
      });
      if (_isExist) {
        print(authenticationEvent.email);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', authenticationEvent.email);
        yield AuthenticationStateSuccess();
      } else {
        yield AuthenticationStateRegisterUser(email: authenticationEvent.email);
      }
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      yield AuthenticationStateFailure();
    }
  }
}
