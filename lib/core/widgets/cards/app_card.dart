import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderHighlightColor;
  final double borderHighlightWidth;
  final bool highlightOnLeft;

  const AppCard({
    super.key,
    required this.child,
    this.elevation = 1.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.backgroundColor,
    this.borderHighlightColor,
    this.borderHighlightWidth = 4.0,
    this.highlightOnLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    if (borderHighlightColor != null) {
      cardContent = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (highlightOnLeft) ...[
              Container(
                width: borderHighlightWidth,
                decoration: BoxDecoration(
                  color: borderHighlightColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  ),
                ),
              ),
            ],
            Expanded(
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
            if (!highlightOnLeft) ...[
              Container(
                width: borderHighlightWidth,
                decoration: BoxDecoration(
                  color: borderHighlightColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
      // Remove padding from outer card container to prevent clipping or gap in the highlight stripe
      cardContent = ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: cardContent,
      );
    }

    return Card(
      elevation: elevation,
      margin: margin,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: borderHighlightColor != null ? cardContent : cardContent,
    );
  }
}
