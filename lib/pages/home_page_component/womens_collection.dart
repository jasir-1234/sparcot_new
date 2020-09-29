import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';
import 'package:sparcotbtc/pages/product/product.dart';

class WomensCollection extends StatelessWidget {
  final arrProductList;

  WomensCollection(this.arrProductList);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 500.0,
      child: Column(
        children: <Widget>[
          TopImageWomensFashion(),
          OfferGridWomensFashion(arrProductList),
        ],
      ),
    );
  }
}

class TopImageWomensFashion extends StatelessWidget {
  var objCondition={
    "arrCategory":["CLEANING SOLUTIONS"]
  };
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image(
          image: AssetImage('assets/top_design/womens_collection.jpg'),
        ),
        Positioned(
          top: 40.0,
          left: 20.0,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0.0),
            width: 320.0,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Cleaning Solutions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.2,
                      ),
                    ),
                    child: Text(
                      'View All',
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WomensWear("Cleaning Solution", objCondition)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OfferGridWomensFashion extends StatelessWidget {
  final arrProductList;
  var objCondition={
    "arrCategory":["CLEANING SOLUTIONS"]
  };
  OfferGridWomensFashion(this.arrProductList);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    InkWell getStructuredGridCell(womensCollectionDeal) {
      final item = womensCollectionDeal;
      return InkWell(
        child: Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(6.0),
                height: 150.0,
                child: Image(
                  image: NetworkImage(item['strImageUrl']),
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text(
                      item["strName"],
                      style: TextStyle(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "₹${item["dblRetailerPrice"].toString()}",
                          style: TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text(
                          "₹${item["dblMRP"].toString()}",
                          style: TextStyle(
                              fontSize: 13.0,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      (100 -
                          ((int.parse(item["dblRetailerPrice"]
                              .toString()) /
                              int.parse(item["dblMRP"]
                                  .toString())) *
                              100))
                          .round()
                          .toString() +
                          "%  Discount",
                      style: TextStyle(
                          color: const Color(0xFF67A86B), fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          var objCondition = {
            "arrCategory": ["KITCHEN COLLECTIONS"]
          };
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductPage(
                    strDocId: item["_id"],
                  )));
        },
      );
    }

    return Column(
      children: <Widget>[
        SizedBox(
          width: width,
          height: 479.0,
          child: Stack(
            children: <Widget>[
              Container(
                width: width,
                height: 460.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFE84958),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                width: width - 20.0,
                margin: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                child: GridView.count(
                  primary: false,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 2,
                  childAspectRatio: ((width) / 500),
                  children: List.generate(arrProductList.length, (index)  {

                    return getStructuredGridCell(arrProductList[index]);
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
