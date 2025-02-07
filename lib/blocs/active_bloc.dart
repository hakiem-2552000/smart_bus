import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/active_event.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/active_state.dart';

class ActiveBloc extends Bloc<ActiveEvent, ActiveState> {
  final UserRepository _userRepository;
  ActiveBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(ActiveStateInitial()); //initial state
  @override
  Stream<ActiveState> mapEventToState(ActiveEvent event) async* {
    if (event is ActiveEventCheckIn) {
      yield ActiveStateLoading();

      Bus currentBus;
      try {
        await _userRepository
            .getBus(busId: event.tripHistory.busId)
            .then((value) {
          currentBus = value;
        });
      } catch (e) {
        print(e);
        yield ActiveStateCheckInFailure();
      }
      if (currentBus.lsUser != null &&
          currentBus.lsUser.indexOf(event.tripHistory.userId) != -1) {
        yield ActiveStateCheckInFailure();
      } else {
        await _userRepository.updateCost(
          userID: event.tripHistory.userId,
          cost: 0,
        );
        List<String> lsUpdate = currentBus.lsUser;
        lsUpdate.add(event.tripHistory.userId);
        try {
          await _userRepository.updateBusLsUser(
            busId: currentBus.busId,
            lsUser: lsUpdate,
          );
          String idTripHistory;
          try {
            await _userRepository
                .addTripHistory(tripHistory: event.tripHistory)
                .then((value) {
              idTripHistory = value;
            });
          } catch (e) {
            yield ActiveStateCheckInFailure();
          }
          try {
            await _userRepository.updateUserTrip(
              userId: event.tripHistory.userId,
              isOnBus: true,
              currentTripId: idTripHistory,
            );
          } catch (e) {
            yield ActiveStateCheckInFailure();
          }
          yield ActiveStateCheckInSuccess();
        } catch (e) {
          print(e);
          yield ActiveStateCheckInFailure();
        }
      }
    } else if (event is ActiveEventCheckOut) {
      yield ActiveStateLoading();
      Bus currentBus;
      try {
        await _userRepository
            .getBus(busId: event.tripHistory.busId)
            .then((value) {
          currentBus = value;
        });
      } catch (e) {
        yield ActiveStateCheckOutFailure();
      }
      if (currentBus.lsUser == null ||
          currentBus.lsUser.indexOf(event.tripHistory.userId) == -1) {
        yield ActiveStateCheckOutFailure();
      } else {
        // tru tien
        double amount;
        int _cost;
        await _userRepository
            .getCoinCustomer(uid: event.tripHistory.userId)
            .then((coin) async {
          await _userRepository
              .getCost(userID: event.tripHistory.userId)
              .then((cost) {
            _cost = cost;
            amount = coin - cost;
          });
        });

        await _userRepository.updateCoinCustomer(
            uid: event.tripHistory.userId, amount: amount.toString());

        List<String> lsUpdate = currentBus.lsUser;
        lsUpdate.remove(event.tripHistory.userId);
        try {
          await _userRepository.updateBusLsUser(
              busId: event.tripHistory.busId, lsUser: lsUpdate);
        } catch (e) {
          yield ActiveStateCheckOutFailure();
        }

        String tripHisID;
        try {
          await _userRepository
              .getCurrentTripID(userId: event.tripHistory.userId)
              .then((value) {
            tripHisID = value;
          });
        } catch (e) {
          yield ActiveStateCheckOutFailure();
        }
        await _userRepository.updateTotalCost(
          tripID: tripHisID,
          cost: _cost,
        );

        try {
          await _userRepository.updateUserTrip(
              userId: event.tripHistory.userId,
              currentTripId: 'null',
              isOnBus: false);
        } catch (e) {
          yield ActiveStateCheckOutFailure();
        }
        try {
          await _userRepository.updateTripHistory(
            idTH: tripHisID,
            endIndex: event.tripHistory.endIndex,
          );
        } catch (e) {
          yield ActiveStateCheckOutFailure();
        }

        List<String> lsUpdateHistory = List<String>();
        await _userRepository
            .getListUserHistory(userID: event.tripHistory.userId)
            .then((value) {
          if (value.isNotEmpty) {
            lsUpdateHistory = value;
          }
        });
        lsUpdateHistory.add(tripHisID);

        await _userRepository.addUserHistoy(
            userID: event.tripHistory.userId, lsUpdate: lsUpdateHistory);
        yield ActiveStateCheckOutSuccess();
      }
    }
  }
}
