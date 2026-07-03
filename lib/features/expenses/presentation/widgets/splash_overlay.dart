import 'package:flutter/material.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_text_styles.dart';

/// Full-screen yellow splash shown while the app boots.
///
/// Mirrors the HTML mock: logo pops in, subtitle slides up, whole overlay
/// fades out after [AppMotion.splashVisible] and is removed at
/// [AppMotion.splashRemove].
class SplashOverlay extends StatefulWidget {
  const SplashOverlay({super.key});

  @override
  State<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<SplashOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _popCtrl;
  late final AnimationController _textCtrl;

  bool _visible = true;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(vsync: this, duration: AppMotion.splashPop)
      ..forward();
    _textCtrl =
        AnimationController(vsync: this, duration: AppMotion.splashTextIn);
    Future<void>.delayed(AppMotion.splashTextDelay, () {
      if (mounted) _textCtrl.forward();
    });

    Future<void>.delayed(AppMotion.splashVisible, () {
      if (mounted) setState(() => _visible = false);
    });
    Future<void>.delayed(AppMotion.splashRemove, () {
      if (mounted) setState(() => _removed = true);
    });
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_removed) return const SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: AppMotion.splashFade,
        curve: Curves.easeOut,
        child: Container(
          color: AppColors.accent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _AnimatedLogo(controller: _popCtrl),
              const SizedBox(height: 18),
              _AnimatedTitle(controller: _textCtrl),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatelessWidget {
  final AnimationController controller;
  const _AnimatedLogo({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Scale keyframes: 0 → 0.6, 60% → 1.06, 100% → 1.
    final Animation<double> scale = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.6, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.06, end: 1.0),
        weight: 40,
      ),
    ]).animate(controller);

    final Animation<double> opacity = CurvedAnimation(
      parent: controller,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) => Opacity(
        opacity: opacity.value,
        child: Transform.scale(scale: scale.value, child: child),
      ),
      child: Container(
        width: 88,
        height: 88,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.onAccent,
          borderRadius: AppRadii.splashAll,
        ),
        child: const Text('÷', style: AppTextStyles.splashLogo),
      ),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final AnimationController controller;
  const _AnimatedTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return FadeTransition(
      opacity: controller,
      child: SlideTransition(
        position: slide,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Splitly', style: AppTextStyles.splashTitle),
            SizedBox(height: 4),
            Text('Split expenses fairly',
                style: AppTextStyles.splashSubtitle),
          ],
        ),
      ),
    );
  }
}
