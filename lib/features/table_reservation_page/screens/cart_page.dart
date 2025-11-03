import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 24.w + 48.w,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          '장바구니',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.10,
            letterSpacing: -0.50,
          ),
        ),
      ),

      body: Column(),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 40.h,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.appPurpleColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 11.h,
                      horizontal: 40.w,
                    ),
                    child: Center(
                      child: Text(
                        '더 담으러 가기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
