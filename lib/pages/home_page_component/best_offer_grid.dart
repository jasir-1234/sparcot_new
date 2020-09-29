import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';

class BestOfferGrid extends StatelessWidget {

  final arrBestOffer;
  BestOfferGrid(this.arrBestOffer);
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    InkWell getStructuredGridCell(bestOffer) {
      return InkWell(
              child: Image(
                image: NetworkImage(bestOffer),
                fit: BoxFit.fitHeight,
              ),
              onTap: () {
                var objCondition={};
                Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WomensWear(
                   "Best of Brands",objCondition)),
          );
              },
            );
    }

    return Container(
      padding: EdgeInsets.all(0.0),
      alignment: Alignment.center,
      width: width - 20.0,
      height: 120.0,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
        children: List.generate(arrBestOffer.length, (index) {
          return getStructuredGridCell(arrBestOffer[index]);
        }),
      ),
    );
  }
}
