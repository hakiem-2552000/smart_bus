import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/blocs/register_bloc.dart';
import 'package:smart_bus/screen/capture_card.dart';

class UserAddNewScreen extends StatefulWidget {
  String email;
  UserAddNewScreen({@required this.email});
  @override
  _UserAddNewScreenState createState() => _UserAddNewScreenState();
}

class _UserAddNewScreenState extends State<UserAddNewScreen> {
  RegisterBloc _registerBloc;
  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CaptureCardScreen(
                        email: widget.email,
                      )));
            },
            child: Text(
              'Scan card',
            )),
      ),
    );
  }
}
