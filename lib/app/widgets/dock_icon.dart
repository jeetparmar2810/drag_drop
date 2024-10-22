import 'package:dragdrop/app/utils/dimens.dart';
import 'package:flutter/material.dart';

/// A widget that represents a draggable and animated dock icon.
class DockIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool isDragging;
  final double dragOffsetX;
  final double Function(int) scaleFactor;
  final void Function(DragStartDetails) onStart;
  final void Function(DragUpdateDetails) onUpdate;
  final VoidCallback onEnd;

  const DockIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.isDragging,
    required this.dragOffsetX,
    required this.scaleFactor,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    const iconSize = Dimens.iconSize;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: Dimens.animationDurationMs),
      curve: Curves.easeInOut,
      left: isDragging ? dragOffsetX : index * iconSize + 15,
      top: 15 - (scaleFactor(index) - 1) * 20, // Adjust vertical position dynamically.
      child: GestureDetector(
        onPanStart: onStart,
        onPanUpdate: onUpdate,
        onPanEnd: (_) => onEnd(),
        child: Transform.scale(
          scale: isDragging ? Dimens.scaleLarge : scaleFactor(index), // Apply smooth scaling.
          child: Opacity(
            opacity: isDragging ? Dimens.opacityMedium : Dimens.opacityFull,
            child: Container(
              width: Dimens.iconWidth,
              height: Dimens.iconHeight,
              margin: const EdgeInsets.all(Dimens.paddingSmall),
              decoration: BoxDecoration(
                color: Colors.primaries[icon.hashCode % Colors.primaries.length],
                borderRadius: BorderRadius.circular(Dimens.borderRadiusLarge),
              ),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}