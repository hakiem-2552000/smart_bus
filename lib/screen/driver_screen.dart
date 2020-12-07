import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/blocs/bus_bloc.dart';
import 'package:smart_bus/blocs/login_bloc.dart';
import 'package:smart_bus/blocs/user_infor_bloc.dart';
import 'package:smart_bus/events/auth_event.dart';
import 'package:smart_bus/events/bus_event.dart';
import 'package:smart_bus/events/login_event.dart';
import 'package:smart_bus/models/trip_history_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/barcode_scanner.dart';
import 'package:smart_bus/states/bus_state.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  BusBloc _busBloc;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    super.initState();
    _busBloc = BlocProvider.of<BusBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

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
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _loginBloc.add(LoginEventStarted());
                    _authenticationBloc.add(AuthenticationEventLoggedOut());
                  }),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            child: SvgPicture.asset('assets/icons/bus.svg'),
                          ),
                          Text(
                            state.bus.busName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                      Container(
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(width: 0, color: Colors.grey)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                'assets/icons/group.svg',
                              ),
                            ),
                            Text(
                              state.bus.lsUser.length.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(width: 0, color: Colors.grey)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  'assets/icons/location.svg',
                                ),
                              ),
                              Text(
                                state.bus.lsStreet[state.bus.currentPosition],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          int previous;
                          if (state.bus.currentPosition == 0) {
                            previous = state.bus.lsStreet.length - 1;
                          } else {
                            previous = state.bus.currentPosition - 1;
                          }
                          _busBloc.add(BusEventUpdateStop(position: previous));
                        },
                        child: Container(
                          width: 110,
                          height: double.maxFinite,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  'assets/icons/back.svg',
                                ),
                              ),
                              Text(
                                state.bus.currentPosition == 0
                                    ? state.bus
                                        .lsStreet[state.bus.lsStreet.length - 1]
                                    : state.bus.lsStreet[
                                        state.bus.currentPosition - 1],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                width: 0,
                                color: Colors.grey,
                              ),
                              right: BorderSide(
                                width: 0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                child: SvgPicture.asset(
                                  'assets/icons/park.svg',
                                ),
                              ),
                              Text(
                                state.bus.lsStreet[state.bus.currentPosition],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          int next;
                          if (state.bus.currentPosition ==
                              state.bus.lsStreet.length - 1) {
                            next = 0;
                          } else {
                            next = state.bus.currentPosition + 1;
                          }
                          _busBloc.add(BusEventUpdateStop(position: next));
                        },
                        child: Container(
                          width: 110,
                          height: double.maxFinite,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  'assets/icons/next.svg',
                                ),
                              ),
                              Text(
                                state.bus.currentPosition ==
                                        state.bus.lsStreet.length - 1
                                    ? state.bus.lsStreet[0]
                                    : state.bus.lsStreet[
                                        state.bus.currentPosition + 1],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
