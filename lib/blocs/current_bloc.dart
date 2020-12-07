import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/bus_event.dart';
import 'package:smart_bus/events/current_event.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/bus_state.dart';
import 'package:smart_bus/states/current_state.dart';

class CurrentBloc extends Bloc<CurrentEvent, CurrentState> {
  final UserRepository _userRepository;
  //constructor
  CurrentBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(CurrentStateInitial()); //initial state

  @override
  Stream<CurrentState> mapEventToState(CurrentEvent event) async* {
    if (event is CurrentEventRequest) {
      yield CurrentStateLoading();
      int cost;
      try {
        await _userRepository.getCurrrentCost().then((value) {
          cost = value;
        });
        yield CurrentStateSuccess(cost: cost);
      } catch (e) {
        yield CurrentStateFailure();
      }
    }
  }
}
