import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/blocs/coin_bloc.dart';
import 'package:smart_bus/blocs/current_bloc.dart';
import 'package:smart_bus/blocs/dashboard_bloc.dart';
import 'package:smart_bus/events/coin_event.dart';
import 'package:smart_bus/events/current_event.dart';
import 'package:smart_bus/events/dashboard_event.dart';
import 'package:smart_bus/main.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/barcode_scanner.dart';
import 'package:smart_bus/screen/capture_card.dart';
import 'package:smart_bus/screen/component/current_trip.dart';
import 'package:smart_bus/screen/ticket_screen.dart';
import 'package:smart_bus/states/auth_state.dart';
import 'package:smart_bus/states/dashboard_state.dart';

import 'component/amount_coin.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DashboardBloc _dashboardBloc;
  CoinBloc _coinBloc;
  String _email = '';
  CurrentBloc _currentBloc;
  @override
  void initState() {
    super.initState();
    _dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    _coinBloc = BlocProvider.of<CoinBloc>(context);
    _currentBloc = BlocProvider.of<CurrentBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TicketScreen()));
            },
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/qr-code.svg'),
            ),
          ),
          InkWell(
            onTap: () {
              _dashboardBloc.add(DashboardEventRequest());
              _coinBloc.add(CoinEventGetAmount());
              _currentBloc.add(CurrentEventRequest());
            },
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/refresh.svg'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardStateSuccess) {
            if (state.isOnBus)
              return RefreshIndicator(
                onRefresh: () async {},
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child:
                                  SvgPicture.asset('assets/icons/coin-2.svg'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            UserCoin(),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                                offset:
                                    Offset(1, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: SvgPicture.asset(
                                        'assets/icons/bus.svg'),
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
                                      right: BorderSide(
                                          width: 0, color: Colors.grey)),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      right: BorderSide(
                                          width: 0, color: Colors.grey)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: SvgPicture.asset(
                                          'assets/icons/location.svg',
                                        ),
                                      ),
                                      Text(
                                        state.bus.lsStreet[
                                            state.bus.currentPosition],
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
                          height: 30,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CurrentTrip(),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              );
            return RefreshIndicator(
              onRefresh: () async {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    child: Text('You didn\'t check in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        )),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
