import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_bus/blocs/bus_bloc.dart';
import 'package:smart_bus/models/trip_history_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/barcode_scanner.dart';
import 'package:smart_bus/states/bus_state.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(builder: (context, state) {
      if (state is BusStateSuccess) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BarcodeScanScreen(
                        bus: state.bus,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/icons/scan.svg'),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              state.bus.lsUser.isEmpty
                  ? Text('0')
                  : Text(state.bus.lsUser.length.toString()),
            ],
          ),
        );
      }
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
