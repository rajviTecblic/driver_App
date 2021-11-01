import 'dart:io';


import 'package:driver/commonFiles/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final  child;
  final  isShow;
   double opacity;
  final Color color;

  // ProgressWidget({this.child, this.isShow, this.opacity, this.color});
  ProgressWidget({

    this.child,
    @required this.isShow,
    this.opacity = 0.3,
    this.color = Colors.grey,
  }) ;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (isShow) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: Platform.isAndroid
                ? CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(AppColors.lightblue),
            )
                : CupertinoActivityIndicator(
              animating: true,
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}


class TextWidget extends StatelessWidget {
   String? text;
   double? fontSize;
   FontWeight? fontWeight;
   Color? color;

   TextWidget({ @required this.text,this.fontSize,this.fontWeight,this.color});

  // ProgressWidget({this.child, this.isShow, this.opacity, this.color});



  @override
  Widget build(BuildContext context) {

    return  Text(text.toString(),style: TextStyle(fontSize: fontSize,fontWeight:fontWeight,color: color, ),);

  }
}