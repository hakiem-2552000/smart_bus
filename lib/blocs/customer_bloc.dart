import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/customer_event.dart';
import 'package:smart_bus/events/user_infor_event.dart';
import 'package:smart_bus/models/customer_model.dart';
import 'package:smart_bus/models/user_infor_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/customer_state.dart';
import 'package:smart_bus/states/user_infor_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final UserRepository _userRepository;
  CustomerBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(CustomerStateInittial());

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is CustomerEventGetByCode) {
      yield CustomerStateLoading();

      Customer customer;
      try {
        await _userRepository.getCustomerByCode(code: event.code).then((value) {
          customer = value;
        });
        yield CustomerStateGetSuccess(customer: customer);
      } catch (e) {
        yield CustomerStateFailure();
      }
    } else {
      if (event is CustomerEventCheckIn) {
        // check customer was check in ?

      }
    }
  }
}
