import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/localization_controller.dart';

class LanguageBottomSheet extends StatelessWidget {
  final LocalizationController controller;

  const LanguageBottomSheet({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'select_language'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: theme.iconTheme.color),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),
          Divider(color: theme.dividerColor, thickness: 1),
          const SizedBox(height: 5),

          // Language list
          Obx(() => ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: controller.languages.length,
            itemBuilder: (context, index) {
              final language = controller.languages[index];
              final isSelected = controller.selectedIndex == index;

              return Material(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    controller.setLanguage(language);
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          language.imageUrl,
                          width: 32,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            language.languageName,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
