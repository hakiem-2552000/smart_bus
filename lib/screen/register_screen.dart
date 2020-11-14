import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_bus/blocs/register_bloc.dart';
import 'package:smart_bus/events/register_event.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/capture_card.dart';
import 'package:smart_bus/screen/login_screen.dart';
import 'package:smart_bus/screen/user_add_new_screen.dart';
import 'package:smart_bus/states/register_state.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _registerBloc.add(RegisterEventInitial());
    // _registerBloc.add(RegisterEventInitial());
    _emailController.addListener(() {
      _registerBloc
          .add(RegisterEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _registerBloc.add(
          RegisterEventPasswordChanged(password: _passwordController.text));
    });
  }

  bool isPopUpAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if (state.isFailure) {
              print('Register failure');
            } else if (state.isSubmitting) {
              print('Register submitting');
            } else if (state.isSuccess) {
              print('Register success');
            }
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/bus.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            'Registration',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            width: double.maxFinite,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            width: double.maxFinite,
                            child: TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            width: double.maxFinite,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          state.isFailure
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Email already exists',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () async {
                              // register
                              if (!state.isValidEmail ||
                                  _emailController.text.isEmpty) {
                                _buildAlert(
                                    message: 'Invalid Email',
                                    desc:
                                        'A valid email address consists of an email prefix and an email domain, both in acceptable formats');
                              } else if (!state.isValidPassword ||
                                  _passwordController.text.isEmpty) {
                                _buildAlert(
                                    message: 'Invalid Password',
                                    desc:
                                        'A valid password must be at least 6 characters long');
                              } else if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                _buildAlert(
                                    message: 'Invalid Confirm Password',
                                    desc:
                                        'Confirm password must be the same password');
                              } else {
                                _registerBloc.add(
                                  RegisterEventPressed(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: _buildGradientButton(),
                          ),
                          _buildBreakLine(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: _buildButton(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  state.isSubmitting
                      ? Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black45,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                  state.isSuccess ? _buildRegisSuccess() : Container(),
                ],
              ),
            );
          },
        ));
  }

  _buildAlert({String message, String desc}) {
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
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  _buildRegisSuccess() {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20),
      color: Colors.black45,
      child: Center(
        child: Container(
          width: double.maxFinite,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.green,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Sign up Success',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    child: Text(
                      'Back to Log In',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
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

  Widget _buildGradientButton() {
    return Container(
      width: double.maxFinite,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(97, 67, 133, 1),
            Color.fromRGBO(81, 99, 149, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: double.maxFinite,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(97, 67, 133, 1),
        ),
      ),
      child: Align(
        child: Text(
          'Log in',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(97, 67, 133, 1),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildBreakLine() {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border.all(width: 0),
              ),
            ),
          ),
          Text(
            '  or  ',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border.all(width: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
