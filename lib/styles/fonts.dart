import 'package:flutter/material.dart';

extension TextStyleExt on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
}

class AppFonts {
  static TextStyle _style(double size, double lh, double lsPercent) =>
      TextStyle(
        fontSize: size,
        height: lh / size,
        letterSpacing: size * lsPercent,
      );

  static final _t1 = _style(28, 38, -0.0236);
  static TextStyle get t1B => _t1.bold;
  static TextStyle get t1M => _t1.medium;
  static TextStyle get t1R => _t1.regular;

  static final _t2 = _style(24, 32, -0.023);
  static TextStyle get t2B => _t2.bold;
  static TextStyle get t2M => _t2.medium;
  static TextStyle get t2R => _t2.regular;

  static final _hd1 = _style(22, 30, -0.0194);
  static TextStyle get hd1SB => _hd1.semiBold;
  static TextStyle get hd1M => _hd1.medium;
  static TextStyle get hd1R => _hd1.regular;

  static final _hd2 = _style(20, 28, -0.012);
  static TextStyle get hd2SB => _hd2.semiBold;
  static TextStyle get hd2M => _hd2.medium;
  static TextStyle get hd2R => _hd2.regular;

  static final _hl1 = _style(18, 26, -0.002);
  static TextStyle get hl1SB => _hl1.semiBold;
  static TextStyle get hl1M => _hl1.medium;
  static TextStyle get hl1R => _hl1.regular;

  static final _hl2 = _style(17, 24, 0);
  static TextStyle get hl2SB => _hl2.semiBold;
  static TextStyle get hl2M => _hl2.medium;
  static TextStyle get hl2R => _hl2.regular;

  static final _b1n = _style(16, 24, 0.0057);
  static TextStyle get b1nSB => _b1n.semiBold;
  static TextStyle get b1nM => _b1n.medium;
  static TextStyle get b1nR => _b1n.regular;

  static final _b1r = _style(16, 26, 0.0057);
  static TextStyle get b1rSB => _b1r.semiBold;
  static TextStyle get b1rM => _b1r.medium;
  static TextStyle get b1rR => _b1r.regular;

  static final _b2n = _style(15, 22, 0.0096);
  static TextStyle get b2nSB => _b2n.semiBold;
  static TextStyle get b2nM => _b2n.medium;
  static TextStyle get b2nR => _b2n.regular;

  static final _b2r = _style(15, 24, 0.0096);
  static TextStyle get b2rSB => _b2r.semiBold;
  static TextStyle get b2rM => _b2r.medium;
  static TextStyle get b2rR => _b2r.regular;

  static final _l1n = _style(14, 20, 0.0145);
  static TextStyle get l1nSB => _l1n.semiBold;
  static TextStyle get l1nM => _l1n.medium;
  static TextStyle get l1nR => _l1n.regular;

  static final _l1r = _style(14, 22, 0.0145);
  static TextStyle get l1rSB => _l1r.semiBold;
  static TextStyle get l1rM => _l1r.medium;
  static TextStyle get l1rR => _l1r.regular;

  static final _l2 = _style(13, 18, 0.0194);
  static TextStyle get l2SB => _l2.semiBold;
  static TextStyle get l2M => _l2.medium;
  static TextStyle get l2R => _l2.regular;

  static final _c1 = _style(12, 16, 0.0252);
  static TextStyle get c1SB => _c1.semiBold;
  static TextStyle get c1M => _c1.medium;
  static TextStyle get c1R => _c1.regular;

  static final _c2 = _style(11, 14, 0.0311);
  static TextStyle get c2SB => _c2.semiBold;
  static TextStyle get c2M => _c2.medium;
  static TextStyle get c2R => _c2.regular;
}

// 사용할때
// Text(
// '중요한 알림',
// style: AppFonts.t2M.copyWith(color: Colors.red),
// // Title 2 / Medium 스타일에 빨간색만 추가
// )
