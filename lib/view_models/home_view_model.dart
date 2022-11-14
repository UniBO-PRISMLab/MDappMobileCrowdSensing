import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/home_model.dart';

class HomeViewModel {
  HomeModel homeModel = HomeModel();

  String getTitle1() {
    return homeModel.title_1;
  }

  setTitle1(String newTitle) {
    homeModel.title_1 = newTitle;
  }

  String getTitle2() {
    return homeModel.title_2;
  }

  setTitle2(String newTitle) {
    homeModel.title_2 = newTitle;
  }

  String getTitle3() {
    return homeModel.title_1;
  }

  setTitle3(String newTitle) {
    homeModel.title_3 = newTitle;
  }

  void goToSourcerView(context) {
    Navigator.pushNamed(context, '/sourcer');
  }

  void goToWorkerView(context) {
    Navigator.pushNamed(context, '/worker');
  }

  void goToVerifierView(context) {
    Navigator.pushNamed(context, '/verifier');
  }

  // go to other pages...
}
