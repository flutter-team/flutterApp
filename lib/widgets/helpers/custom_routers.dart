import 'package:flutter/material.dart';
class CustomRouter<T> extends MaterialPageRoute<T>{
 
  CustomRouter({WidgetBuilder builder,RouteSettings settings}):super(builder:builder,settings:settings);
@override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
   if(settings.isInitialRoute){
     return child;
   }
    return FadeTransition(opacity:animation ,child: child,);
  
  }
}