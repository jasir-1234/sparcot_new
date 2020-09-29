import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final arrSize;
  final arrColor;
  var objColor=null;
  var objSize=null;
  ProductSize(this.arrSize,this.arrColor);
  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  Color activeColor = Colors.blue;
  Color nonActiveColor = Colors.grey[100];
  Color activeColorBorder = Colors.black;
  List arrSizeWidget=new List <Widget>();
  List arrColorWidget=new List <Widget>();
  var minAxisAlgnSize=MainAxisAlignment.spaceEvenly;
  var minAxisAlgnColor=MainAxisAlignment.spaceEvenly;
  var intColorIndex=0;
  var intSizeIndex=0;
  @override
  Widget build(BuildContext context) {

    arrSizeWidget.clear();
    arrColorWidget.clear();
    widget.objSize=widget.arrSize.length!=0?widget.arrSize[0]:{};
    widget.objColor=widget.arrColor.length!=0? widget.arrColor[0]:{};
    for (var i=0;i<widget.arrSize.length;i++){
      var objItem=widget.arrSize[i];
      arrSizeWidget.add(InkWell(
        child: Container(
          width: 50.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                color:i==intSizeIndex?activeColor:nonActiveColor ),
            borderRadius: BorderRadius.circular(10.0),
            color:  Colors.white ,
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            objItem["strName"]!=null?objItem["strName"]:"",
            style: TextStyle(
                color:  Colors.black ,
                fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          intSizeIndex=i;
          arrSizeWidget.clear();
          arrColorWidget.clear();
          widget.objSize=widget.arrSize[i];
          minAxisAlgnSize;
          setState(() {
          });
        },
      ));
    }
    for (var i=0;i<widget.arrColor.length;i++){
      var objItem=widget.arrColor[i];
      var intColorCode=int.parse("0x"+objItem["strColorCode"].toString().toUpperCase());
      arrColorWidget.add(InkWell(
        child: Container(
          width: 50.0,
          height: 50.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                color:  i==intColorIndex?activeColor:nonActiveColor , width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
            color: new Color(intColorCode),
          ),
          child:  Container(
            child: Icon(Icons.check,
              color: new Color(intColorCode),
            ),
          ),
        ),
        onTap: () {
          intColorIndex=i;
          widget.objColor=widget.arrColor[i];
          arrColorWidget.clear();
          arrSizeWidget.clear();
          minAxisAlgnColor;
          setState(() {
          });
        },
      ));
    }
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Size',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Tip: For the best fit, buy one size larger than your usual size.',
            style: TextStyle(fontSize: 12.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: minAxisAlgnSize,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:arrSizeWidget.length!=0?arrSizeWidget:[Container()],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(height: 1.0),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Color',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: minAxisAlgnColor,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: arrColorWidget.length!=0?arrColorWidget:[Container()],
            ),
          ),
        ],
      ),
    );
  }
}
