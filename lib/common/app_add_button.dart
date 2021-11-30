import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louzero/controller/constant/colors.dart';
import 'package:louzero/controller/utils.dart';

class AppAddButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  const AppAddButton(this.label, {Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.medium_2),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            appIcon(Icons.add_circle, color: AppColors.dark_2),
            const SizedBox(width: 8),
            Text(label, style: TextStyles.labelL.copyWith(color: AppColors.dark_3)),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}