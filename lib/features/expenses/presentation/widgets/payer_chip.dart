import 'package:flutter/material.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_text_styles.dart';

class PayerChip extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const PayerChip({
    super.key,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? AppColors.accent : AppColors.surface;
    final Color fg =
        selected ? AppColors.onAccent : AppColors.foregroundMuted;
    final Color border =
        selected ? AppColors.accent : AppColors.outlineStrong;
    final Color avatarBg =
        selected ? AppColors.accentTintOnAccent : AppColors.accentTint;
    final Color avatarFg = selected ? AppColors.onAccent : AppColors.accent;

    return Semantics(
      label: name,
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: AppMotion.chipMorph,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: AppRadii.lgAll,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.lgAll,
            child: Focus(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Semantics(
                      excludeSemantics: true,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: avatarBg,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          name.characters.first,
                          style: AppTextStyles.payerChipInitial
                              .copyWith(color: avatarFg),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTextStyles.payerChipLabel.copyWith(color: fg),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
