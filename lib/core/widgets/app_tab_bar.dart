import 'package:flutter/material.dart';
import '../theme/lumina_theme.dart';

/// 统一的 TabBar 导航切换组件
///
/// 特性：
/// 1. 禁用 Material 3 默认延伸至全屏边缘的沉重 dividerColor；
/// 2. 提供可配置的浅色/深色弱化下分割线，且默认左右留有边距（不顶格）；
/// 3. 同时适配 [AppBar.bottom]（实现 [PreferredSizeWidget]）以及普通 [Column] 页面局部布局；
/// 4. 统一主色调指示器与标签排版规范。
class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController? controller;
  final List<Widget> tabs;
  final bool isScrollable;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? indicatorColor;
  final double indicatorWeight;
  final TabBarIndicatorSize? indicatorSize;
  final Decoration? indicator;
  final bool showDivider;
  final Color? dividerColor;
  final EdgeInsetsGeometry dividerPadding;
  final double dividerHeight;
  final ValueChanged<int>? onTap;
  final TabAlignment? tabAlignment;
  final double height;

  const AppTabBar({
    super.key,
    this.controller,
    required this.tabs,
    this.isScrollable = false,
    this.backgroundColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorColor,
    this.indicatorWeight = 3.0,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.indicator,
    this.showDivider = true,
    this.dividerColor,
    this.dividerPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.dividerHeight = 1.0,
    this.onTap,
    this.tabAlignment,
    this.height = 48.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(height + (showDivider ? dividerHeight : 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectivePrimary = indicatorColor ?? LuminaColors.primary;
    final effectiveLabelColor = labelColor ?? effectivePrimary;
    final effectiveUnselectedColor = unselectedLabelColor ??
        (isDark ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF64748B));

    final effectiveDividerColor = dividerColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04));

    final effectiveIndicator = indicator ??
        UnderlineTabIndicator(
          borderSide: BorderSide(width: indicatorWeight, color: effectivePrimary),
          insets: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: const BorderRadius.all(Radius.circular(3)),
        );

    final tabBarWidget = TabBar(
      controller: controller,
      tabs: tabs,
      isScrollable: isScrollable,
      tabAlignment: tabAlignment ?? (isScrollable ? TabAlignment.start : null),
      dividerColor: Colors.transparent, // 禁用 M3 原生顶格分割线
      indicatorColor: effectivePrimary,
      indicatorWeight: indicatorWeight,
      indicatorSize: indicatorSize,
      indicator: effectiveIndicator,
      labelColor: effectiveLabelColor,
      unselectedLabelColor: effectiveUnselectedColor,
      labelStyle: labelStyle ??
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
      unselectedLabelStyle: unselectedLabelStyle ??
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
      onTap: onTap,
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: tabBarWidget,
        ),
        if (showDivider)
          Padding(
            padding: dividerPadding,
            child: Container(
              height: dividerHeight,
              color: effectiveDividerColor,
            ),
          ),
      ],
    );

    if (backgroundColor != null) {
      return Container(
        color: backgroundColor,
        child: content,
      );
    }

    return content;
  }
}
