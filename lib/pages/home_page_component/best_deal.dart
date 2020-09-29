import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';

class BestDealGrid extends StatelessWidget {

  final bestDealList = [
    {'title': 'Latest Winter Collection', 'image': 'assets/best_deal/best_deal_1.jpg'},
    {
      'title': 'Bedsheets, Curtains & More',
      'image': 'assets/best_deal/best_deal_2.jpg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
var objCondition={};
    InkWell getStructuredGridCell(bestDeal) {
      final item = bestDeal;
      return InkWell(
        child: Image(
          image: AssetImage(item['image']),
          fit: BoxFit.fitHeight,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WomensWear( "Products",objCondition)),
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.all(0.0),
      alignment: Alignment.center,
      width: width - 20.0,
      height: 250.0,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        crossAxisCount: 2,
        childAspectRatio: ((width) / 500),
        children: List.generate(bestDealList.length, (index) {
          return getStructuredGridCell(bestDealList[index]);
        }),
      ),
    );
  }
}
