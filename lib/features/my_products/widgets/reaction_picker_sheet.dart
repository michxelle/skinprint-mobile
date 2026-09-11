import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/app_text_styles.dart';
import '/features/my_products/models/product_reaction.dart';
import 'reaction_label.dart';

Future<ProductReaction?>
    showReactionPicker(
  BuildContext context, {
  ProductReaction? currentReaction,
}) {
  return showModalBottomSheet<
      ProductReaction>(
    context: context,
    backgroundColor:
        Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              24,
              12,
              24,
              30,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration:
                        BoxDecoration(
                      color:
                          AppColors.border,
                      borderRadius:
                          BorderRadius.circular(
                        100,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'How did this product work for you?',
                  style:
                      AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 10),

                Text(
                  'Your answer becomes part of '
                  'your Skinprint and will be used '
                  'for personalized comparisons.',
                  style:
                      AppTextStyles.bodyMedium(),
                ),

                const SizedBox(height: 26),

                _ReactionOption(
                  reaction:
                      ProductReaction.worked,
                  currentReaction:
                      currentReaction,
                ),

                const Divider(),

                _ReactionOption(
                  reaction:
                      ProductReaction.didntWork,
                  currentReaction:
                      currentReaction,
                ),

                const Divider(),

                _ReactionOption(
                  reaction:
                      ProductReaction.neutral,
                  currentReaction:
                      currentReaction,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _ReactionOption
    extends StatelessWidget {
  final ProductReaction reaction;

  final ProductReaction?
      currentReaction;

  const _ReactionOption({
    required this.reaction,
    required this.currentReaction,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrent =
        reaction == currentReaction;

    return InkWell(
      onTap: () {
        Navigator.pop(
          context,
          reaction,
        );
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 18,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: 48,
              color:
                  reactionColor(reaction),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reaction.label,
                          style:
                              AppTextStyles.bodyLarge()
                                  .copyWith(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      if (isCurrent)
                        Text(
                          'CURRENT',
                          style:
                              AppTextStyles.label(
                            color:
                                AppColors.primaryAction,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    reaction.description,
                    style:
                        AppTextStyles.bodyMedium(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}