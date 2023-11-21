import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuizPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50.0,
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
          SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            height: 100.0,
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
          SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            height: 50.0,
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
            height: 50.0,
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
            height: 50.0,
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
            height: 50.0,
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