import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension TextStyleExt on BuildContext {
  TextStyle get bigTitle => AppTextStyles.displayLarge;
  TextStyle get title => AppTextStyles.titleLarge;
  TextStyle get titleMideum => AppTextStyles.titleMedium;
  TextStyle get bodyLarge => AppTextStyles.bodyLarge;
  TextStyle get body => AppTextStyles.bodyMedium;
  TextStyle get bodySmall => AppTextStyles.bodySmall;
  TextStyle get caption => AppTextStyles.caption;
  TextStyle get captionAccent => AppTextStyles.captionAccent;
  TextStyle get button => AppTextStyles.buttonLabel;
  TextStyle get hint => AppTextStyles.hintText;
}

class AppTextStyles {
  // 1. 공통 폰트 패밀리 지정 (필요 시)
  static const String _fontFamily = 'Pretendard';

  // --- Display & Title (크고 강조되는 텍스트) ---
  static const displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  ); // 기존 mainTitle

  static const titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  static const titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  ); // 기존 homeMainRoasteryTitle

  // --- Body (일반 본문) ---
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  ); // 기존 homeSectionTitle, productItemTitle

  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  ); // 기존 body

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  ); // 기존 productTitle

  // --- Label & Caption (정보성, 보조 텍스트) ---
  static const labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    color: AppColors.hintTextColor,
  ); // 기존 userInfoTitle

  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  ); // 기존 homeCategoryTitle, productItemCupnote

  static const captionAccent = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
    decoration: TextDecoration.underline,
    decorationColor: Colors.white,
    decorationThickness: 2,
    decorationStyle: TextDecorationStyle.solid,
  );

  // --- Specialized (특수 목적 - 강조/버튼/가격) ---
  static const buttonLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const priceLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.bold, // 실무에선 가격은 보통 볼드 처리
    color: AppColors.productPriceColor,
  );

  static const linkText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
    decoration: TextDecoration.underline,
    decorationColor: Colors.white,
    decorationThickness: 2,
  );

  static const hintText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.hintTextColor,
  );
}
