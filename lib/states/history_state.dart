import 'package:equatable/equatable.dart';

import 'package:smart_bus/models/bank_model.dart';
import 'package:smart_bus/models/detail_history.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HistoryStateInitial extends HistoryState {}

class HistoryStateLoading extends HistoryState {}

class HistoryStateSuccess extends HistoryState {
  final List<DetailHistory> listDetail;
  HistoryStateSuccess({this.listDetail});
}
