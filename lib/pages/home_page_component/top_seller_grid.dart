import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers.dart';
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';
class TopSeller extends StatelessWidget {

  final topSellerList = [
    {'title': 'Top Selling Mobile Phones', 'image': 'assets/top_seller/top_seller_1.jpg'},
    {
      'title': 'Top Selling TVs',
      'image': 'assets/top_seller/top_seller_2.jpg'
    },   
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
var objCondition={};
    InkWell getStructuredGridCell(topSeller) {
      final item = topSeller;
      return InkWell(
              child: Image(
                image: AssetImage(item['image']),
                fit: BoxFit.fitHeight,
              ),
              onTap: () {
                Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WomensWear('${item['title']}',objCondition)),
          );
              },
            );
    }

    return Container(
      padding: EdgeInsets.all(0.0),
      alignment: Alignment.center,
      width: width - 20.0,
      height: 180.0,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        children: List.generate(topSellerList.length, (index) {
          return getStructuredGridCell(topSellerList[index]);
        }),
      ),
    );
  }
}
