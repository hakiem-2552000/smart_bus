import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/dashboard_event.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/models/trip_history_model.dart';

import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepository _userRepository;
  //constructor
  DashboardBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(DashboardStateInitial());
  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is DashboardEventRequest) {
      yield DashboardStateLoading();
      bool _isOnBUs;
      await _userRepository.isUserOnBus().then((value) {
        _isOnBUs = value;
      });
      if (_isOnBUs) {
        try {
          String currentTripID;
          await _userRepository
              .getUserCurrentTrip()
              .then((value) => currentTripID = value);
          TripHistory _tripHistory;
          await _userRepository
              .getTripHistory(tripID: currentTripID)
              .then((value) => _tripHistory = value);
          //
          Bus _bus;
          await _userRepository
              .getBus(busId: _tripHistory.busId)
              .then((value) => _bus = value);
          yield DashboardStateSuccess(
            isOnBus: true,
            bus: _bus,
            tripHistory: _tripHistory,
          );
        } catch (e) {
          yield DashboardStateFailure();
          print(e);
        }
      } else {
        yield DashboardStateSuccess(
          isOnBus: false,
        );
      }
    }
  }
}
