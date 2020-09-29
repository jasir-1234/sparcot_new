import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// My Own Imports
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';

class FeaturedBrandSlider extends StatelessWidget {
final featuredBrandList;
FeaturedBrandSlider(this.featuredBrandList);
  @override
  Widget build(BuildContext context) {
    InkWell getStructuredGridCell(featuredBrand) {
      final item = featuredBrand;
      return InkWell(
        onTap: () {
          var objCondition={"arrBrands":[item["strName"]]};
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WomensWear("Featured Brands",objCondition)),
          );
        },
        child: Image(
          image: NetworkImage(item['strImgUrl_0']),
        ),
      );
    }

    return Container(
      height: 305.0,
      padding: EdgeInsets.only(bottom: 0.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12.0),
            alignment: Alignment.topLeft,
            child: Text(
              'Featured Brands',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          CarouselSlider(
            height: 250.0,
            enlargeCenterPage: true,
            items: List.generate(featuredBrandList.length, (index) {
              return getStructuredGridCell(featuredBrandList[index]);
            }),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
        ],
      ),
    );
  }
}
