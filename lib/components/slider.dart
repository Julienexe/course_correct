import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWigdet extends StatefulWidget {
  final List<Widget>items;
  CarouselWigdet({super.key, required this.items});

  @override
  State<CarouselWigdet> createState() => _CarouselWigdetState();
}

class _CarouselWigdetState extends State<CarouselWigdet> {
  
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
       height: 430,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Container(
        child: Center(
          child: widget.items[itemIndex],
        ),
      ),
    );
  }
}
