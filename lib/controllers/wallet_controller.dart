import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/views/login_view.dart';
import '../models/smart_contract_model.dart';
import '../models/wallet_model.dart';
import '../utils/styles.dart';
import 'package:flip_card/flip_card.dart';

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
  String balance = "LOADING...", symbol = "MCScoin";

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
           Column(
                children: [
                  Text(
                    "You are logged with the Account:",
                    style: CustomTextStyle.spaceMonoBold(context),
                  ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 30),
              width: double.maxFinite,
              child:FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        session.getAccountAddress(),
                        style: CustomTextStyle.spaceMono(context),
                      ))),
                ],
              ),
          _buildCoinWidget(balance, symbol),

        ])),
        onWillPop: () async {
          timer.cancel();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
          return true;
        });
  }

  Widget _formatBalance(String balance) {
    double? parsed = double.tryParse(balance);
    if (parsed != null && balance != "0") {
      parsed = parsed / 1000000000000000000;
      return Text(
        parsed.toString(),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        balance,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _buildCoinWidget(String balance, String symbol) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            symbol,
            style: const TextStyle(fontSize: 25),
          ),
          SizedBox(
            width: 300,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    FlipCard(
                      direction: FlipDirection.VERTICAL, // default
                      front: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/coin_back.png',
                              width: 150, height: 150),
                        ],
                      ),
                      back: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/coin.png',
                              width: 150, height: 150),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _formatBalance(balance)
        ],
      ),
    );
  }
}
