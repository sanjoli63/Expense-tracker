import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.green,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Colors.brown,
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                  color: Colors.white10,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New shoes',
    //   amount: 69.66,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'clothes',
    //   amount: 800.65,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't3',
    //   title: 'purse',
    //   amount: 500,
    //   date: DateTime.now(),
    // ),
  ];
  List<Transaction> get _recentT {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAdd(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final apBar = AppBar(
      title: Text(
        'Personal Expense Tracker',
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAdd(context),
        ),
      ],
    );
    return Scaffold(
      appBar: apBar,
      body: SingleChildScrollView(
        child: Container(
          // height: 700,
          // color: Theme.of(context).primaryColor,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Container(
              //   padding: EdgeInsets.all(5),
              //   width: double.infinity,
              //   child: Card(
              //     child: Center(
              //       child: Text(
              //         'Expenses',
              //         style: TextStyle(
              //           color: Colors.purple,
              //           fontStyle: FontStyle.italic,
              //           fontSize: 25,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //     color: Colors.pink[200],
              //     elevation: 6,
              //   ),
              // ),
              Container(
                child: Chart(_recentT),
                height: (MediaQuery.of(context).size.height -
                        apBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.4,
              ),
              Container(
                  height: (MediaQuery.of(context).size.height -
                          apBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.6,
                  child:
                      TransactionList(_userTransactions, _deleteTransaction)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAdd(context),
      ),
    );
  }
}
