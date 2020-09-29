import 'package:flutter/material.dart';
import 'package:sparcotbtc/Api/SearchApi.dart';

import 'package:sparcotbtc/pages/product/product.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  var arrList = [];


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width * 0.7;
    double height = MediaQuery
        .of(context)
        .size
        .height;


    double widthFull = MediaQuery.of(context).size.width;
    var objCondition = {};
    return Scaffold(
        appBar: AppBar(
          title: TextField(


            controller: searchController,
            onChanged: (searchController) async{
              var search = searchController.toString();
              arrList = await searchProduct(
                  search);
              setState(() {

              });
              print("staaaaaaaaaaaaaaaatus");
              print(arrList);


              // this.setState(() {});
              //    print(searchController);

            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search for Products',
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
              suffixIcon: Icon(Icons.search, color: Colors.white),
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          titleSpacing: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),

          itemCount: arrList != null ? arrList.length : 0,

          itemBuilder: (context, index) {

            final item = arrList != null ? arrList[index] : null;
            print("lisssssssssst");
            print(arrList);

            return Container(
                child: InkWell(
                  onTap: () {
                    print("object\n\n\n\nn\n.........");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductPage(
                            strDocId: item["_id"],
                          )),
                    );
//                        Navigator.of(context).push(PageRouteBuilder(
//                            pageBuilder: (_, __, ___) => new TrackingPage()));
//                           Navigator.push(context, SlideLeftRoute(page: TrackingPage()));
                  },
                  child: Card(
                      elevation: 5.0,
                      child: Stack(
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.only(
                                top: (height / 40.0), bottom: (height / 40.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 120.0,
                                          height: ((height - 200.0) / 4.0),
                                          alignment: Alignment.center,
                                          child: Image(

                                            image: ["strImageUrl"] !=
                                                null
                                                ? NetworkImage(
                                                item
                                                ["strImageUrl"])
                                                : AssetImage(
                                                "assets/payment_icon/cash_on_delivery.png"),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      width: (width - 20.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[


                                          Text(
                                            '${item['strName']}',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Price:',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                '₹${item['dblRetailerPrice']}',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7.0,
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
              // height: (height / 4.5),
            );
          },


        ));
  }
}