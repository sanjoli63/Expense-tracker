import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

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
  ];
  bool _showChart = false;

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

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar apBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart', style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              child: Chart(_recentT),
              height: (mediaQuery.size.height -
                      apBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar apBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        child: Chart(_recentT),
        height: (mediaQuery.size.height -
                apBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget apBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expense Tracker',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAdd(context),
                ),
              ],
            ),
          )
        : AppBar(
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
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              apBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                ..._buildLandscapeContent(
                  mediaQuery,
                  apBar,
                  txListWidget,
                ),
              if (!isLandscape)
                ..._buildPortraitContent(
                  mediaQuery,
                  apBar,
                  txListWidget,
                ),
            ],
          ),
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: apBar,
          )
        : Scaffold(
            appBar: apBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAdd(context),
                  ),
          );
  }
}
