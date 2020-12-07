import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_bus/events/coin_event.dart';
import 'package:smart_bus/events/history_event.dart';
import 'package:smart_bus/models/detail_history.dart';
import 'package:smart_bus/models/history_model.dart';

import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/coin_state.dart';
import 'package:smart_bus/states/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final UserRepository _userRepository;
  //constructor
  HistoryBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(HistoryStateInitial()); //initial state

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    if (event is HistoryEventRequest) {
      yield HistoryStateLoading();
      List<History> listHistory;
      await _userRepository.getListHistory().then((value) {
        listHistory = value;
      });
      List<DetailHistory> listDetail = List<DetailHistory>();
      for (int i = 0; i < listHistory.length; i++) {
        await _userRepository.getBus(busId: listHistory[i].busId).then((value) {
          listDetail.add(new DetailHistory(
            startName: value.lsStreet[listHistory[i].startIndex],
            endName: value.lsStreet[listHistory[i].endIndex],
            total: listHistory[i].total,
          ));
        });
      }
      yield HistoryStateSuccess(
        listDetail: listDetail,
      );
    }
  }
}
