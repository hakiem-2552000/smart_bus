import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/user_infor_event.dart';
import 'package:smart_bus/models/user_infor_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/user_infor_state.dart';

class UserInforBloc extends Bloc<UserInforEvent, UserInforState> {
  final UserRepository _userRepository;
  UserInforBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(UserInforStateInitial());

  @override
  Stream<UserInforState> mapEventToState(UserInforEvent event) async* {
    if (event is UserInforEventFetch) {
      yield UserInforStateFetching();
      try {
        UserInfor _userInfor;
        await UserRepository().fetchUserInfor().then((value) {
          _userInfor = value;
        });
        yield UserInforStateGetSuccess(userInfor: _userInfor);
      } catch (e) {
        yield UserInforStateFailure();
      }
    }
  }
}
