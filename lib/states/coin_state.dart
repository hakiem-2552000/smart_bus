import 'package:equatable/equatable.dart';

abstract class CoinState extends Equatable {
  const CoinState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CoinStateInitial extends CoinState {}

class CoinStateLoading extends CoinState {}

class CoinStateGetSuccess extends CoinState {
  final String amount;
  CoinStateGetSuccess({this.amount});
}

class CoinStateDoesNotExist extends CoinState {}

class CoinStateFailure extends CoinState {}
