import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class UserElement extends StatelessWidget {
  final String title;
  final String content;
  final Icon icon;

  UserElement({this.content, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Align(child: icon),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey)),
            Text(content,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
    );
  }
}
