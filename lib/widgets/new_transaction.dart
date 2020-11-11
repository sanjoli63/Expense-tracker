import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submittedData() {
    final enterdTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enterdTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    widget.addTx(
      enterdTitle,
      enteredAmount,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onSubmitted: (_) => submittedData(),
              // onChanged: (val) => titleInput = val,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submittedData(),
              // onChanged: (val) {
              //   amountInput = val;
              // },
            ),
            FlatButton(
              onPressed: submittedData,
              child: Text('Add Transaction'),
              textColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
