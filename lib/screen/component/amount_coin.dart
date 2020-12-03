import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/blocs/coin_bloc.dart';
import 'package:smart_bus/states/coin_state.dart';

class UserCoin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinBloc, CoinState>(builder: (context, state) {
      if (state is CoinStateGetSuccess) {
        return Text(
          state.amount + '\$',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        );
      }
      return Text('Loading...');
    });
  }
}
