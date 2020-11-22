import 'package:equatable/equatable.dart';
import 'package:smart_bus/models/user_infor_model.dart';

abstract class UserInforState extends Equatable {
  const UserInforState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserInforStateInitial extends UserInforState {}

class UserInforStateGetSuccess extends UserInforState {
  UserInfor userInfor;
  UserInforStateGetSuccess({this.userInfor});
}

class UserInforStateFetching extends UserInforState {}

class UserInforStateFailure extends UserInforState {}
