import 'package:awesome_card/awesome_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_bus/models/bank_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/component/amount_coin.dart';
import 'package:smart_bus/screen/credit_card_screen.dart';
import 'package:smart_bus/screen/recharge_screen.dart';
import 'package:smart_bus/screen/withdraw_screen.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isActiveBank = false;
  bool _showBack = false;
  Bank _bank;
  String cardNumber = "";
  String cardHolderName = "";
  String expiryDate = "";
  String cvv = "";
  @override
  void initState() {
    super.initState();
    checkExistBank();
    _getInforBank();
  }

  void checkExistBank() async {
    UserRepository().isExistBank().then((value) {
      setState(() {
        _isActiveBank = value;
      });
    });
  }

  void _getInforBank() async {
    print('get Infor');
    setState(() {
      _isActiveBank = true;
    });
    await UserRepository().getInforBank().then((value) {
      _bank = value;
    });
    setState(() {
      cardNumber = _bank.cardNumber;
      cardHolderName = _bank.cardHolderName;
      expiryDate = _bank.dateExpiry;
      cvv = _bank.cvv;
    });
  }

  void getIt() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreditCardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  UserCoin(),
                ],
              ),
              DottedBorder(
                radius: Radius.circular(10),
                padding: EdgeInsets.all(8),
                color: Colors.grey,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => WithdrawScreen()));
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child:
                                  SvgPicture.asset('assets/icons/withdraw.svg'),
                            ),
                          ),
                          Text(
                            'Withdraw',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => RechargeScreen()));
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              child:
                                  SvgPicture.asset('assets/icons/wallet.svg'),
                            ),
                          ),
                          Text(
                            'Recharge',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CreditCard(
                cardNumber: cardNumber,
                cardExpiry: expiryDate,
                cardHolderName: cardHolderName,
                cvv: cvv,
                bankName: "Kiem Bank",
                frontBackground: CardBackgrounds.black,
                backBackground: CardBackgrounds.white,
                showShadow: true,
                cardType: CardType.masterCard,
                showBackSide: _showBack,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showBack = !_showBack;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.rotate_right,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Rotate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreditCardScreen(),
                    ),
                  ).then((value) {
                    if (value) {
                      _getInforBank();
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DottedBorder(
                    radius: Radius.circular(10),
                    padding: EdgeInsets.all(8),
                    color: Colors.grey,
                    child: Row(
                      children: [
                        _isActiveBank
                            ? Icon(
                                Icons.settings,
                                color: Colors.grey,
                                size: 35,
                              )
                            : Icon(
                                LineIcons.plus_circle,
                                color: Colors.grey,
                                size: 35,
                              ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          _isActiveBank
                              ? 'Change your credit card '
                              : 'Add your credit card',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
