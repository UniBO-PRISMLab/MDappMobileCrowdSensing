import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import '../models/wallet_model.dart';
import '../utils/styles.dart';

class WalletController extends StatefulWidget {
  const WalletController({Key? key}) : super(key: key);

  @override
  State<WalletController> createState() => _WalletControllerState();
}

class _WalletControllerState extends State<WalletController> {
  SessionModel session = SessionModel();
  Object? parameters;
  dynamic jsonInfo = {};
  late Timer timer;
  String balance = "LOADING...", symbol = "LOADING...";

  Future<void> _getBalance() async {
    String data = await WalletModel.getData();
    jsonInfo = jsonDecode(data);
    symbol = jsonInfo['symbol'].toString();
    balance = jsonInfo['balance'].toString();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _getBalance();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "You are logged with the Account:",
                    style: CustomTextStyle.spaceMonoBold(context),
                  ),
                  FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        session.getAccountAddress(),
                        style: CustomTextStyle.spaceMono(context),
                      )),
                ],
              )),
          buildCoinWidget(balance, symbol)
        ])),
        onWillPop: () async {
          timer.cancel();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
          return true;
        });
  }
}

Widget _formatBalance(String balance) {
  if (double.tryParse(balance) != null) {
    return Text(
      '${balance.substring(0, 2)},${balance.substring(3)}',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  } else {
    return Text(
      balance,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

Widget buildCoinWidget(String balance, String symbol) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          symbol,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(
          height: 20,
        ),
        Image.asset('assets/images/coin.png', width: 150, height: 150),
        const SizedBox(
          height: 20,
        ),
        _formatBalance(balance)
      ],
    ),
  );
}
