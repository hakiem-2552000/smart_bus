import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/coin_event.dart';

import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final UserRepository _userRepository;
  //constructor
  CoinBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(CoinStateInitial()); //initial state

  @override
  Stream<CoinState> mapEventToState(CoinEvent event) async* {
    if (event is CoinEventGetAmount) {
      yield CoinStateLoading();
      bool _isExist = false;
      try {
        await _userRepository.isExistCoin().then((value) {
          _isExist = value;
        });
      } catch (e) {
        yield CoinStateFailure();
      }

      if (_isExist) {
        try {
          String _amount;
          await _userRepository.getCoin().then((value) {
            _amount = value;
          });
          yield CoinStateGetSuccess(amount: _amount);
        } catch (e) {
          yield CoinStateFailure();
        }
      } else {
        await _userRepository.updateCoin(amount: '0');
        yield CoinStateGetSuccess(amount: '0');
      }
    }
  }
}
