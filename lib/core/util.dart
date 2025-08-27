import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Util {
  /// Convert hex string (#RRGGBB or #AARRGGBB) to [Color]
  static Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // add full opacity if not provided
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Shimmer rectangle / box
  static Widget shimmerBox({
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shimmer circle
  static Widget shimmerCircle({
    double size = 50,
    EdgeInsetsGeometry? margin,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: size,
        height: size,
        margin: margin,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Shimmer square
  static Widget shimmerSquare({
    double size = 50,
    EdgeInsetsGeometry? margin,
  }) {
    return shimmerBox(width: size, height: size, margin: margin);
  }
}
