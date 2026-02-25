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
    this.borderRadius = 20,
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
        boxShadow: hasShadow && gradientColors == null
            ? [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 20,
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

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final List<Color>? gradientColors;
  final double? width;
  final double height;

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
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildChild(context),
        ),
      );
    }

    Widget button;
    if (gradientColors != null) {
      button = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors!,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradientColors!.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _buildChild(context),
        ),
      );
    } else {
      button = SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildChild(context),
        ),
      );
    }

    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
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
    this.borderRadius = 20,
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
