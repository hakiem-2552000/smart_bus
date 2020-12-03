import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/blocs/login_bloc.dart';
import 'package:smart_bus/blocs/user_infor_bloc.dart';
import 'package:smart_bus/events/auth_event.dart';
import 'package:smart_bus/events/login_event.dart';
import 'package:smart_bus/events/user_infor_event.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/component/user_element.dart';
import 'package:smart_bus/screen/user_add_new_screen.dart';
import 'package:smart_bus/states/user_infor_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isExistedUser = false;
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;
  UserInforBloc _userInforBloc;
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _userInforBloc = BlocProvider.of<UserInforBloc>(context);
    // _userInforBloc.add(UserInforEventFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.logout,
      //         color: Colors.black,
      //       ),
      //       onPressed: () {
      //         _loginBloc.add(LoginEventStarted());
      //         _authenticationBloc.add(AuthenticationEventLoggedOut());
      //       },
      //     )
      //   ],
      // ),
      body:
          BlocBuilder<UserInforBloc, UserInforState>(builder: (context, state) {
        if (state is UserInforStateGetSuccess) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(251, 194, 235, 1),
                            Color.fromRGBO(166, 193, 238, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(200),
                          bottomRight: Radius.circular(200),
                        ),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 70,
                      top: 120,
                      child: Container(
                        width: 150,
                        height: 150,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://d1nhio0ox7pgb.cloudfront.net/_img/o_collection_png/green_dark_grey/512x512/plain/user.png',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                    ),
                  ],
                ),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      UserElement(
                        title: 'Name',
                        content: state.userInfor.name ?? '',
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
                        content: state.userInfor.email ?? '',
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
                        title: 'Birth',
                        content: state.userInfor.age ?? '',
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
                        content: state.userInfor.code ?? '',
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
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    _loginBloc.add(LoginEventStarted());
                    _authenticationBloc.add(AuthenticationEventLoggedOut());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      width: double.maxFinite,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.grey,
                          ],
                        ),
                      ),
                      child: Align(
                        child: Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
