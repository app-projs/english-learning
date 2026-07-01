import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final double borderRadius;
  final bool hasShadow;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.gradientColors,
    this.borderRadius = 24, // 统一为 24px 大圆角
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors!,
              )
            : null,
        color: gradientColors == null
            ? (isDark ? AppColors.darkCard : AppColors.lightCard)
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        // 均匀边框以保证圆角兼容性
        border: gradientColors == null
            ? Border.all(
                color: isDark ? const Color(0xFF2B3035) : const Color(0xFFE5E7EB),
                width: 1.5,
              )
            : null,
        // 将 3D 立体底座移入 shadow 以彻底避免带圆角非均匀 border 引起的异常
        boxShadow: hasShadow && gradientColors == null
            ? [
                // 3D 实体偏置底座
                BoxShadow(
                  color: isDark ? const Color(0xFF1E2124) : const Color(0xFFD1D5DB),
                  offset: const Offset(0, 4.5),
                  blurRadius: 0,
                ),
                // 软阴影
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.35)
                      : const Color(0xFF9CA3AF).withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardContent,
        ),
      );
    }

    if (margin != null) {
      return Padding(padding: margin!, child: cardContent);
    }

    return cardContent;
  }
}

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final List<Color>? gradientColors;
  final double? width;
  final double height;
  final Color? backgroundColor;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.gradientColors,
    this.width,
    this.height = 52,
    this.backgroundColor,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    if (isDisabled) {
      return _buildButtonBody(context, isPressed: false, isDisabled: true);
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: _buildButtonBody(context, isPressed: _isPressed, isDisabled: false),
    );
  }

  Widget _buildButtonBody(BuildContext context, {required bool isPressed, required bool isDisabled}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Q弹的按压深度
    final double depth = isPressed ? 0.0 : 4.0;

    if (widget.isOutlined) {
      return SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: Stack(
          children: [
            // 底部 3D 厚度
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2B3035) : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            // 顶部可按压层
            AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              margin: EdgeInsets.only(bottom: 4.0 - depth, top: depth),
              width: widget.width ?? double.infinity,
              height: widget.height - 4.0,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1D20) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDisabled
                      ? (isDark ? const Color(0xFF495057) : const Color(0xFFCED4DA))
                      : primaryColor,
                  width: 2.0,
                ),
              ),
              child: Center(child: _buildChild(context, isDisabled: isDisabled)),
            ),
          ],
        ),
      );
    }

    // 计算主色与底部 3D 厚度阴影颜色
    Color btnColor = widget.backgroundColor ?? primaryColor;
    Color bottomColor;

    if (widget.gradientColors != null && widget.gradientColors!.isNotEmpty) {
      btnColor = widget.gradientColors!.first;
      // 用后半部分作为深度颜色
      bottomColor = widget.gradientColors!.last.withRed((widget.gradientColors!.last.red * 0.82).toInt())
                                              .withGreen((widget.gradientColors!.last.green * 0.82).toInt())
                                              .withBlue((widget.gradientColors!.last.blue * 0.85).toInt());
    } else if (widget.backgroundColor != null) {
      bottomColor = HSLColor.fromColor(widget.backgroundColor!).withLightness(
        (HSLColor.fromColor(widget.backgroundColor!).lightness - 0.15).clamp(0.0, 1.0)
      ).toColor();
    } else {
      // 皇家紫对应的 3D 深厚度色
      bottomColor = const Color(0xFF5E39C4);
    }

    if (isDisabled) {
      btnColor = isDark ? const Color(0xFF2B3035) : const Color(0xFFE5E7EB);
      bottomColor = isDark ? const Color(0xFF1E2124) : const Color(0xFFD1D5DB);
    }

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: Stack(
        children: [
          // 底部 3D 立体厚度
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          // 顶部可按压层
          AnimatedContainer(
            duration: const Duration(milliseconds: 60),
            margin: EdgeInsets.only(bottom: 4.0 - depth, top: depth),
            width: widget.width ?? double.infinity,
            height: widget.height - 4.0,
            decoration: BoxDecoration(
              gradient: (!isDisabled && widget.gradientColors != null)
                  ? LinearGradient(
                      colors: widget.gradientColors!,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              color: (isDisabled || widget.gradientColors == null) ? btnColor : null,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(child: _buildChild(context, isDisabled: isDisabled)),
          ),
        ],
      ),
    );
  }

  Widget _buildChild(BuildContext context, {required bool isDisabled}) {
    if (widget.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    final textColor = widget.isOutlined
        ? (isDisabled ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF495057) : const Color(0xFFCED4DA)) : Theme.of(context).primaryColor)
        : (isDisabled ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.white);

    final textWidget = Text(
      widget.text,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          textWidget,
        ],
      );
    }

    return textWidget;
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final List<Color> colors;

  const GradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.colors = AppColors.gradientPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(opacity)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressClamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                backgroundColor ??
                    (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progressClamped,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppColors.primary,
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const Badge({
    super.key,
    required this.text,
    this.color = AppColors.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ModernButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ListTileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const ListTileItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
