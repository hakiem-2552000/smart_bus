import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_bus/blocs/coin_bloc.dart';
import 'package:smart_bus/events/coin_event.dart';
import 'package:smart_bus/repositories/user_repository.dart';

import 'component/amount_coin.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _editingController = TextEditingController();

  _updateAmount() async {
    print('update');
    double _currrentAmount;
    double _withdrawAmount = double.parse(_editingController.text);
    await UserRepository().getCoin().then((value) {
      print(value.toString());
      _currrentAmount = double.parse(value);
    }).catchError((e) {
      print(e);
    });
    double balance = _currrentAmount - _withdrawAmount;
    await UserRepository().updateCoin(amount: balance.toString());
    BlocProvider.of<CoinBloc>(context).add(CoinEventGetAmount());
    _editingController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset('assets/icons/coin-2.svg'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Account Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  UserCoin(),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _editingController,
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {},
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    hintText: 'Withdraw',
                    hintStyle: TextStyle(fontSize: 15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(48, 193, 189, 1), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade100, width: 0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _updateAmount();
                      },
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.grey,
                            ],
                          ),
                        ),
                        child: Align(
                          child: Text(
                            'Withdraw',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
