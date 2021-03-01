import 'package:flutter/material.dart';

class UserTransaction extends StatefulWidget {
  @override
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[100],
      child: Column(
        children: <Widget>[
          Card(
            child: Center(
              child: Text(
                'List Of Transactions:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            color: Colors.teal,
            elevation: 6,
          ),
        ],
      ),
    );
  }
}
