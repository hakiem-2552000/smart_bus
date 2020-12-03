import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/bus_event.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  final UserRepository _userRepository;
  //constructor
  BusBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(BusStateInitial()); //initial state
  @override
  Stream<BusState> mapEventToState(BusEvent event) async* {
    if (event is BusEventRequest) {
      yield BusStateLoading();
      try {
        String busId;
        await _userRepository.getBusId().then((value) {
          busId = value;
        });
        print(busId);
        Bus bus;
        await _userRepository.getBus(busId: busId).then((value) {
          bus = value;
        });
        yield BusStateSuccess(bus: bus);
      } catch (e) {
        print(e);
        yield BusStateFailure();
      }
    }
  }
}
