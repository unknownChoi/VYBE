import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vybe/core/app_text_style.dart';

class TicketActionSpec {
  const TicketActionSpec({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
}

class TicketActionRow extends StatelessWidget {
  const TicketActionRow({super.key, required this.specs})
    : assert(specs.length == 2);

  final List<TicketActionSpec> specs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ActionButton(
            label: specs[0].label,
            bgColor: specs[0].color,
            onTap: specs[0].onTap,
          ),
          const Spacer(),
          _ActionButton(
            label: specs[1].label,
            bgColor: specs[1].color,
            onTap: specs[1].onTap,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.bgColor,
    required this.onTap,
  });

  final String label;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.actionButton,
        ),
      ),
    );
  }
}
