import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPlaceholder extends StatelessWidget {
  var cellHeight = 100.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            height: cellHeight,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor:  Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            height: cellHeight,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor:  Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            height: cellHeight,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor:  Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            height: cellHeight,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor:  Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}