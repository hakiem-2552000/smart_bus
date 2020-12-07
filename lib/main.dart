import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_bus/blocs/active_bloc.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/blocs/bus_bloc.dart';
import 'package:smart_bus/blocs/coin_bloc.dart';
import 'package:smart_bus/blocs/current_bloc.dart';
import 'package:smart_bus/blocs/customer_bloc.dart';
import 'package:smart_bus/blocs/dashboard_bloc.dart';
import 'package:smart_bus/blocs/history_bloc.dart';

import 'package:smart_bus/blocs/login_bloc.dart';
import 'package:smart_bus/blocs/register_bloc.dart';
import 'package:smart_bus/blocs/user_infor_bloc.dart';
import 'package:smart_bus/events/bus_event.dart';
import 'package:smart_bus/events/coin_event.dart';
import 'package:smart_bus/events/current_event.dart';
import 'package:smart_bus/events/dashboard_event.dart';
import 'package:smart_bus/events/history_event.dart';
import 'package:smart_bus/events/user_infor_event.dart';
import 'package:smart_bus/navigation_bar.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/driver_screen.dart';
import 'package:smart_bus/screen/error_screen.dart';
import 'package:smart_bus/screen/home_screen.dart';
import 'package:smart_bus/screen/loading_screen.dart';
import 'package:smart_bus/screen/login_screen.dart';
import 'package:smart_bus/screen/register_screen.dart';
import 'package:smart_bus/screen/splash_screen.dart';
import 'package:smart_bus/screen/user_add_new_screen.dart';
import 'package:smart_bus/states/auth_state.dart';

import 'blocs/simple_bloc_obsever.dart';
import 'events/auth_event.dart';

final userRepository = UserRepository();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) =>
          AuthenticationBloc(userRepository: userRepository)
            ..add(AuthenticationEventStarted()),
    ),
    BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: userRepository)),
    BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: userRepository)),
    BlocProvider<UserInforBloc>(
        create: (context) => UserInforBloc(userRepository: userRepository)),
    BlocProvider<CoinBloc>(
        create: (context) => CoinBloc(userRepository: userRepository)),
    BlocProvider<CustomerBloc>(
        create: (context) => CustomerBloc(userRepository: userRepository)),
    BlocProvider<BusBloc>(
        create: (context) => BusBloc(userRepository: userRepository)),
    BlocProvider<ActiveBloc>(
        create: (context) => ActiveBloc(userRepository: userRepository)),
    BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc(userRepository: userRepository)),
    BlocProvider<HistoryBloc>(
        create: (context) => HistoryBloc(userRepository: userRepository)),
    BlocProvider<CurrentBloc>(
        create: (context) => CurrentBloc(userRepository: userRepository)),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (_) => SplashScreen.route(),
      builder: (context, child) {
        return ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(
                context,
                MultiBlocListener(
                  listeners: [
                    BlocListener<AuthenticationBloc, AuthenticationState>(
                      child: child,
                      listener: (context, authenticationState) async {
                        if (authenticationState is AuthenticationStateSuccess) {
                          BlocProvider.of<DashboardBloc>(context)
                              .add(DashboardEventRequest());
                          BlocProvider.of<UserInforBloc>(context)
                              .add(UserInforEventFetch());
                          BlocProvider.of<CoinBloc>(context)
                              .add(CoinEventGetAmount());
                          BlocProvider.of<HistoryBloc>(context)
                              .add(HistoryEventRequest());
                          BlocProvider.of<CurrentBloc>(context)
                              .add(CurrentEventRequest());
                          _navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => NavigationBar(),
                              ),
                              (route) => false);
                        } else if (authenticationState
                            is AuthenticationStateFailure) {
                          _navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        } else if (authenticationState
                            is AuthenticationStateInitial) {
                          _navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        } else if (authenticationState
                            is AuthenticationStateRegisterUser) {
                          _navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => UserAddNewScreen(
                                  email: authenticationState.email,
                                ),
                              ),
                              (route) => false);
                        } else if (authenticationState
                            is AuthenticationStateLoggedOut) {
                          _navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        } else if (authenticationState
                            is AuthenticationStateIsDriver) {
                          BlocProvider.of<BusBloc>(context)
                              .add(BusEventRequest());
                          _navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DriverScreen(),
                              ),
                              (route) => false);
                        }
                      },
                    ),
                  ],
                  child: child,
                )),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ]);
      },
    );
  }
}
