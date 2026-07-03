import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_spacing.dart';
import 'package:splitly/core/theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final double maxW = MediaQuery.of(context).size.width * 0.75;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxl,
          horizontal: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _DashedCircle(
              size: 74,
              child: Text('÷', style: AppTextStyles.emptyGlyph),
            ),
            AppSpacing.vGapLg,
            const Text('No expenses yet', style: AppTextStyles.emptyTitle),
            AppSpacing.vGapXs,
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW.clamp(220, 400)),
              child: const Text(
                "Add your group's first shared expense and Splitly will work out who owes what.",
                textAlign: TextAlign.center,
                style: AppTextStyles.emptyBody,
              ),
            ),
            const SizedBox(height: 18),
            _EmptyCta(onTap: onAdd),
          ],
        ),
      ),
    );
  }
}

class _EmptyCta extends StatefulWidget {
  final VoidCallback onTap;
  const _EmptyCta({required this.onTap});

  @override
  State<_EmptyCta> createState() => _EmptyCtaState();
}

class _EmptyCtaState extends State<_EmptyCta> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapCancel: () => setState(() => _scale = 1),
      onTapUp: (_) => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: AppMotion.buttonPress,
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 11,
          ),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: AppRadii.pillAll,
          ),
          child: Semantics(
            label: 'Add an expense',
            button: true,
            excludeSemantics: true,
            child: const Text(
              'Add an expense',
              style: AppTextStyles.emptyCta,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashed border circle used as the empty-state icon frame.
class _DashedCircle extends StatelessWidget {
  final double size;
  final Widget child;

  const _DashedCircle({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(child: child),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.emptyDash
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const int dashCount = 22;
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    const double gapRatio = 0.45;
    final double step = 2 * math.pi / dashCount;
    final double dashArc = step * (1 - gapRatio);

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * step;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 1),
        startAngle,
        dashArc,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) => false;
}
