import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/events/register_event.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/register_state.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/validators/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    if (registerEvent is RegisterEventInitial) {
      yield RegisterState.initial();
    } else if (registerEvent is RegisterEventEmailChanged) {
      yield state.cloneAndUpdate(
        isValidEmail: Validators.isValidEmail(registerEvent.email),
      );
    } else if (registerEvent is RegisterEventPasswordChanged) {
      yield state.cloneAndUpdate(
        isValidPassword: Validators.isValidPassword(registerEvent.password),
      );
    } else if (registerEvent is RegisterEventPressed) {
      yield RegisterState.loading();
      try {
        await _userRepository.createUserWithEmailAndPassword(
          email: registerEvent.email,
          password: registerEvent.password,
        );
        yield RegisterState.success();
      } catch (exception) {
        yield RegisterState.failure();
      }
    }

    throw UnimplementedError();
  }
}
