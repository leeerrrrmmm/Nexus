import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';

class PortfolioTextLinkButton extends StatelessWidget {
  const PortfolioTextLinkButton({
    super.key,
    required this.label,
    required this.link,
    this.dark = false,
    this.fontSize,
  });

  final String label;
  final PortfolioLink link;
  final bool dark;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? const Color(0xFF0F172A) : Colors.white;
    final border = dark
        ? const Color(0xFF0F172A).withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.55);

    return TextButton(
      onPressed: () => PortfolioLinkScope.of(context)(link),
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: border, width: 1.2),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize ?? 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
