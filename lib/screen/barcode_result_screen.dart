import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_bus/blocs/active_bloc.dart';
import 'package:smart_bus/blocs/bus_bloc.dart';
import 'package:smart_bus/blocs/customer_bloc.dart';
import 'package:smart_bus/events/active_event.dart';
import 'package:smart_bus/events/bus_event.dart';
import 'package:smart_bus/events/customer_event.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/models/trip_history_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/states/active_state.dart';
import 'package:smart_bus/states/bus_state.dart';
import 'package:smart_bus/states/customer_state.dart';

import 'component/user_element.dart';

class BarcodeResultScreen extends StatefulWidget {
  final String barcode;
  final Bus bus;

  BarcodeResultScreen({this.barcode, this.bus});
  @override
  _BarcodeResultScreenState createState() => _BarcodeResultScreenState();
}

class _BarcodeResultScreenState extends State<BarcodeResultScreen> {
  CustomerBloc _customerBloc;
  BusBloc _busBloc;
  ActiveBloc _activeBloc;
  @override
  void initState() {
    super.initState();
    _customerBloc = BlocProvider.of<CustomerBloc>(context);
    _customerBloc.add(CustomerEventGetByCode(code: widget.barcode));
    _busBloc = BlocProvider.of<BusBloc>(context);
    _activeBloc = BlocProvider.of<ActiveBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveBloc, ActiveState>(
        listener: (context, activeState) {
          if (activeState is ActiveStateCheckInSuccess) {
            _busBloc.add(BusEventRequest());
            _buildAlert(message: 'Check in successfull');
          } else if (activeState is ActiveStateCheckInFailure) {
            _buildError(message: 'The user has checked in');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
            ),
            title:
                Text('Check Customer', style: TextStyle(color: Colors.black)),
          ),
          body: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
            if (state is CustomerStateGetSuccess) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          UserElement(
                            title: 'Name',
                            content: state.customer.name ?? '',
                            icon: Icon(
                              LineIcons.user,
                              size: 35,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          UserElement(
                            title: 'Email',
                            content: state.customer.email ?? '',
                            icon: Icon(
                              Icons.alternate_email_outlined,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          UserElement(
                            title: 'D.O.B',
                            content: state.customer.age ?? '',
                            icon: Icon(
                              Icons.access_time,
                              size: 30,
                              color: Colors.yellow[800],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          UserElement(
                            title: 'Code',
                            content: state.customer.code ?? '',
                            icon: Icon(
                              Icons.qr_code_rounded,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            _activeBloc.add(
                              ActiveEventCheckIn(
                                tripHistory: TripHistory(
                                  busId: widget.bus.busId,
                                  startIndex: widget.bus.currentPosition,
                                  endIndex: -1,
                                  userId: state.customer.uid,
                                  isDone: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Align(
                              child: Text(
                                'Check In',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            _activeBloc.add(
                              ActiveEventCheckOut(
                                tripHistory: TripHistory(
                                  busId: widget.bus.busId,
                                  startIndex: widget.bus.currentPosition,
                                  endIndex: widget.bus.currentPosition,
                                  userId: state.customer.uid,
                                  isDone: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Align(
                              child: Text(
                                'Check Out',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              );
            }
            if (state is CustomerStateFailure) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/error.png'),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'User does not exist',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Go back',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      )),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
        ));
  }

  _buildAlert({String message, String desc}) {
    Alert(
      context: context,
      type: AlertType.success,
      title: message,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          width: 120,
        )
      ],
    ).show();
  }

  _buildError({String message, String desc}) {
    Alert(
      context: context,
      type: AlertType.error,
      title: message,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
}
