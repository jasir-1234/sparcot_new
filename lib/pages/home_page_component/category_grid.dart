import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';

class CategoryGrid extends StatelessWidget {
  final categoryList;

  CategoryGrid(this.categoryList);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    InkWell getStructuredGridCell(category) {
      final item = category;
      return InkWell(
        child: Image(
          image: NetworkImage(item['strImgUrl_0']),
          fit: BoxFit.fitHeight,
        ),
        onTap: () {
          var objCondition = {
            "arrCategory":[item["strName"]]
          };
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WomensWear(item["strName"], objCondition)),
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      width: width - 20.0,
      height: 200.0,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 0,
        mainAxisSpacing: 15,
        crossAxisCount: 4,
        children: List.generate(categoryList.length, (index) {
          return getStructuredGridCell(categoryList[index]);
        }),
      ),
    );
  }
}
