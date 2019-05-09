import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  final String price;

  Price(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.5),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(3.0)),
        child: Text(
          '\$${price.toString()}',
          style: TextStyle(color: Colors.white),
        ));
  }
}
