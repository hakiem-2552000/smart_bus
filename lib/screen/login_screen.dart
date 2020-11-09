import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/blocs/login_bloc.dart';
import 'package:smart_bus/events/auth_event.dart';
import 'package:smart_bus/events/login_event.dart';
import 'package:smart_bus/navigation_bar.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/home_screen.dart';
import 'package:smart_bus/screen/register_screen.dart';
import 'package:smart_bus/states/login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChange(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _loginBloc
          .add(LoginEventPasswordChange(password: _passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.isFailure) {
            print('Login failure');
          } else if (state.isSubmitting) {
            print('Login submitting');
          } else if (state.isSuccess) {
            print('Login success');
            _authenticationBloc
                .add(AuthenticationEventLoggedIn(email: _emailController.text));
          }
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/bus.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'In',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(97, 67, 133, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: double.maxFinite,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          width: double.maxFinite,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
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
                                  'Email or password incorrect.',
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
                          onTap: () {
                            //login
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
                            } else {
                              _loginBloc.add(LoginEventPressed(
                                  email: _emailController.text,
                                  password: _passwordController.text));
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
                                    builder: (context) => RegisterScreen()));
                          },
                          child: _buildButton(),
                        ),
                      ],
                    ),
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
            ],
          );
        },
      ),
    );
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
          'Log in',
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
          'Register',
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
