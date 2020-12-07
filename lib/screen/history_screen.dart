import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_bus/blocs/history_bloc.dart';
import 'package:smart_bus/events/history_event.dart';
import 'package:smart_bus/states/history_state.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryBloc _historyBloc;
  @override
  void initState() {
    super.initState();
    _historyBloc = BlocProvider.of<HistoryBloc>(context);
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
              _historyBloc.add(HistoryEventRequest());
            },
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/refresh.svg'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryStateSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                _historyBloc.add(HistoryEventRequest());
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      state.listDetail.length > 0
                          ? Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              child: Expanded(
                                child: ListView.builder(
                                  itemCount: state.listDetail.length,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return _buildHistory(
                                      startName: state
                                          .listDetail[state.listDetail.length -
                                              index -
                                              1]
                                          .startName,
                                      endName: state
                                          .listDetail[state.listDetail.length -
                                              index -
                                              1]
                                          .endName,
                                      total: state
                                          .listDetail[state.listDetail.length -
                                              index -
                                              1]
                                          .total,
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: Text('You don\'t have history'),
                            ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _buildHistory({String startName, String endName, int total}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 60,
      padding: EdgeInsets.all(10),
      width: double.maxFinite,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.history,
            size: 30,
            color: Colors.grey,
          ),
          Text(
            startName + ' - ' + endName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            total.toString() + '\$',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.yellow[600]),
          ),
        ],
      ),
    );
  }
}
