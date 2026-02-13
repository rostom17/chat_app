import 'package:chat_app/core/config/size_config.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColorLight,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      bodyLarge: TextStyle(color: AppColors.whiteColor),

      bodyMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
        foregroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.blackColor),
    ),

    dialogTheme: DialogThemeData(backgroundColor: Colors.white),

  );

  static ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarColorDark,
      elevation: 0,
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),

      bodyLarge: TextStyle(color: AppColors.whiteColor),

      bodyMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black12),
        foregroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.whiteColor),
    ),

    dialogTheme: DialogThemeData(backgroundColor: AppColors.appBarColorDark),
  );
}
