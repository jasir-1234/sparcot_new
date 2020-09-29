import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:sparcotbtc/pages/category/filter.dart';
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';

class FilterRow extends StatefulWidget {
  final arrSelectedBrands, arrSelectedCategory;

  FilterRow(this.arrSelectedBrands, this.arrSelectedCategory);

  @override
  _FilterRowState createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  int selectedRadioSort;
  bool satVal = false;
  bool sunVal = false;

  @override
  void initState() {
    super.initState();
    selectedRadioSort = 0;
  }

  setSelectedRadioSort(int val) {
    var ObjCondition = {};
    if (val == 1) {
      ObjCondition["strSort"] = "dblTotalSales";
      if (selectedRadioSort == val) ObjCondition["strSortActive"] = "DESC";
    } else if (val == 2) {
      ObjCondition["strSort"] = "dblRetailerPrice";
    } else if (val == 3) {
      ObjCondition = {"strSort": "dblRetailerPrice", "strSortActive": "DESC"};
    } else if (val == 4) {
      ObjCondition["strSort"] = "strCreatedTime";
      if (selectedRadioSort == val) ObjCondition["strSortActive"] = "DESC";
    } else {}
    setState(() {
      if (selectedRadioSort != val)
        selectedRadioSort = val;
      else
        selectedRadioSort = 0;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WomensWear("Sorted Products", ObjCondition)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              _sortModalBottomSheet(context);
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sort,
                    size: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Sort',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 20.0,
            width: 1.0,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          InkWell(
            onTap: () {
              var arrSelectedBrands = [], arrSelectedCategory = [];
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      page: Filter(arrSelectedBrands, arrSelectedCategory)));
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.filter_list,
                    size: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Filter',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sortModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'SORT BY',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Divider(
                          height: 1.0,
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue: selectedRadioSort,
                          title: Text("Popularity"),
                          onChanged: (val) {
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          value: 2,
                          groupValue: selectedRadioSort,
                          title: Text("Price -- Low to High"),
                          onChanged: (val) {
                            print("val.......");
                            print(val);
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          value: 3,
                          groupValue: selectedRadioSort,
                          title: Text("Price -- High to Low"),
                          onChanged: (val) {
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile(
                          value: 4,
                          groupValue: selectedRadioSort,
                          title: Text("Newest First"),
                          onChanged: (val) {
                            setSelectedRadioSort(val);
                          },
                          activeColor: Colors.blue,
                        ),
//                        RadioListTile(
//                          value: 4,
//                          groupValue: selectedRadioSort,
//                          title: Text("Name"),
//                          onChanged: (val) {
//                            setSelectedRadioSort(val);
//                          },
//                          activeColor: Colors.blue,
//                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
