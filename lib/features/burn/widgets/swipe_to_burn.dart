import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/burn_controller.dart';

class SwipeToBurn extends StatelessWidget {
  const SwipeToBurn({required this.controller, super.key});

  final BurnController controller;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      container: true,
      explicitChildNodes: true,
      label: 'Confirm burn',
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 0) {
            controller.handleSwipeEnd(BurnController.swipeThreshold);
            unawaited(
              controller.confirm(
                reducedMotion: MediaQuery.of(context).disableAnimations,
              ),
            );
          }
        },
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Swipe to burn',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
