import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/blocs/current_bloc.dart';
import 'package:smart_bus/states/current_state.dart';

class CurrentTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentBloc, CurrentState>(builder: (context, state) {
      if (state is CurrentStateSuccess) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.maxFinite,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.teal[200],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(1, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.yellow[600],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Current Amount:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                state.cost.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
