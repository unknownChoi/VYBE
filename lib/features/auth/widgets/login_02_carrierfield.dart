// lib/widgets/auth/ui02_carrier_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/auth/utils/login_02_constants.dart';

class Login02CarrierField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String)? onCarrierSelected;
  const Login02CarrierField({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.onCarrierSelected,
  });

  static Future<void> showCarrierModal({
    required BuildContext context,
    required TextEditingController controller,
    Function(String)? onCarrierSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.modelSheetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Container(
            height: 432.h,
            decoration: BoxDecoration(
              color: AppColors.modelSheetColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "통신사를 선택해주세요.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24.h),
                ...kCarriers.map(
                  (carrier) => ListTile(
                    title: Text(
                      carrier,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, carrier),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null) {
      controller.text = selected;
      onCarrierSelected?.call(selected);
    }
  }

  @override
  State<Login02CarrierField> createState() => _Ui02CarrierFieldState();
}

class _Ui02CarrierFieldState extends State<Login02CarrierField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  Future<void> _showCarrierModal(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.modelSheetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Container(
            height: 432.h,
            decoration: BoxDecoration(
              color: AppColors.modelSheetColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "통신사를 선택해주세요.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24.h),
                ...kCarriers.map(
                  (carrier) => ListTile(
                    title: Text(
                      carrier,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, carrier),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null) {
      widget.controller.text = selected;
      widget.onCarrierSelected?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color underlineColor =
        widget.controller.text.isNotEmpty
            ? AppColors.appPurpleColor
            : Colors.white;

    return GestureDetector(
      onTap: () => _showCarrierModal(context),
      child: AbsorbPointer(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.60.sp,
            ),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                size: 35.sp,
                color: Colors.white,
              ),
              hintText: "통신사를 선택해주세요.",
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.60.sp,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: underlineColor, width: 2.w),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: underlineColor, width: 2.w),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
