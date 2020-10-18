import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_bus/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SafeArea(
          child: SingleChildScrollView(
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
                      fit: BoxFit.fitWidth,
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
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {},
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
