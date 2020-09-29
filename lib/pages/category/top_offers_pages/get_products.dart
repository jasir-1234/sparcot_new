import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers_pages/filter_row.dart';
import 'package:sparcotbtc/pages/product/product.dart';

class GetProducts extends StatefulWidget {
  final arrProductList, arrSelectedBrands, arrSelectedCategory;
  GetProducts(
      this.arrProductList, this.arrSelectedBrands, this.arrSelectedCategory);

  @override
  _GetProductsState createState() => _GetProductsState();
}

class _GetProductsState extends State<GetProducts> {
  ScrollController _scrollController = ScrollController();
  int _currentMax = 4;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      shrinkWrap: true,
      children: <Widget>[
        FilterRow(widget.arrSelectedBrands,widget.arrSelectedCategory),
        Divider(
          height: 1.0,
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0),
            child: ProductsGridView(widget.arrProductList)),
      ],
    );
//            : Center(
//                child: SpinKitFoldingCube(
//                color: Theme.of(context).primaryColor,
//                size: 35.0,
//              ));
  }

  void _getMoreData() {


     print("count");
    _currentMax = _currentMax + 4;

    setState(() {});
  }
}





class ProductsGridView extends StatefulWidget {
  final arrProductList;

  ProductsGridView(this.arrProductList);

  @override
  _ProductsGridViewState createState() =>
      _ProductsGridViewState(this.arrProductList);
}

class _ProductsGridViewState extends State<ProductsGridView> {
  final arrProductLists;

  _ProductsGridViewState(this.arrProductLists);

  InkWell getStructuredGridCell(var objProduct) {
    double height = MediaQuery.of(context).size.height;
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
            Hero(
              tag: '${objProduct["strName"]}',
              child: Container(
                // height: 185.0,
                height: ((height - 150.0) / 2.95),
                margin: EdgeInsets.all(6.0),
                child: Image(
                  image: NetworkImage(objProduct["strImageUrl"]),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 6.0, left: 6.0),
              child: Column(
                children: <Widget>[
                  Text(
                    objProduct["strName"],
                    style: TextStyle(fontSize: 12.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "₹${objProduct["dblRetailerPrice"].toString()}",
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      Text(
                        "₹${objProduct["dblMRP"].toString()}",
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
                                ((int.parse(objProduct["dblRetailerPrice"]
                                            .toString()) /
                                        int.parse(
                                            objProduct["dblMRP"].toString())) *
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                      strDocId: objProduct["_id"],
                    )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GridView.count(

      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 2,
      childAspectRatio: ((width) / (height - 150.0)),
      children: List.generate(arrProductLists.length, (index) {
        return getStructuredGridCell(arrProductLists[index]);

      }),
    );
  }
}
