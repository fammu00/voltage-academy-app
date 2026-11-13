import 'package:flutter/material.dart';

class UiSpacer {
  static Widget hSpace([double space = 20]) => SizedBox(width: space);
  static Widget vSpace([double space = 20]) => SizedBox(height: space);

  // space between widgets vertically
  static Widget verticalSpace({double space = 20}) => SizedBox(height: space);

  // space between widgets horizontally
  static Widget horizontalSpace({double space = 20}) => SizedBox(width: space);

  static Widget formVerticalSpace({double space = 15}) =>
      SizedBox(height: space);

  static Widget emptySpace() => const SizedBox.shrink();

  static Widget expandedSpace() => const Expanded(
    child: SizedBox.shrink(),
  );

  static Widget divider({double height = 1, double thickness = 1}) => Divider(
    height: height,
    thickness: thickness,
  );

  static Widget slideIndicator() => Container(
    width: 100,
    height: 4,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.grey.shade400,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
