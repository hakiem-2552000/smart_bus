import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CoinEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CoinEventGetAmount extends CoinEvent {}

class CoinEventUpdateAmount extends CoinEvent {}
