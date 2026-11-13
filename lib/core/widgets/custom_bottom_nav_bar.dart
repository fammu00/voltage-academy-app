import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../theme/app_colors.dart';
import '../utils/ui_spacer.dart';
import 'custom_image_widget.dart';

class NavItem {
  final String icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItem> items;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E), // AppColors.primaryColor,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(20),
          //   topRight: Radius.circular(20),
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
                (index) =>
                _buildNavItem(items[index].icon, items[index].label, index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   icon,
            //   color: isSelected ? Colors.black : Colors.white,
            //   size: 24,
            // ),
            CustomImageWidget(
              height: 20,
              width: 20,
              imagePath: icon,
              color: isSelected ? Colors.black : Colors.white,
            ),
            UiSpacer.verticalSpace(
              space: 5,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black  : Colors.white,
                fontSize:Dimensions.font12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
