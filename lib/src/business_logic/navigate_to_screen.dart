import 'package:flutter/material.dart';

class NavigateToScreen{

  navToScreen(context,screen){
    Navigator.of(context).push(
        MaterialPageRoute(
        builder: (context) {
        return screen;}));
  }
}