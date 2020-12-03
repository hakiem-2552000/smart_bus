import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/main.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/barcode_scanner.dart';
import 'package:smart_bus/screen/capture_card.dart';
import 'package:smart_bus/screen/ticket_screen.dart';
import 'package:smart_bus/states/auth_state.dart';

import 'component/amount_coin.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String _email = '';
  @override
  void initState() {
    super.initState();
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
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icons/coin-2.svg'),
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
                padding: EdgeInsets.all(5),
                width: double.maxFinite,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
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
                          'Bus 1',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    Container(
                      height: double.maxFinite,
                      width: 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset('assets/icons/people.svg'),
                        ),
                        Text(
                          '8',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_history,
                    size: 40,
                  ),
                  Text(
                    'Current Location: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Tôn Đức Thắng ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_history,
                    size: 40,
                  ),
                  Text(
                    'Start point: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Trần Hưng Đạo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_history,
                    size: 40,
                  ),
                  Text(
                    'Stop point: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Nguyễn Thái Bình',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset('assets/icons/bill.svg'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Estimated amount: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '12\$',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
