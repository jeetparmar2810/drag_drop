import 'package:dragdrop/app/utils/dimens.dart';
import 'package:flutter/material.dart';

class DockIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool isDragging;
  final double dragOffsetX;
  final double Function(int) calculateScale;
  final void Function(DragStartDetails) onPanStart;
  final void Function(DragUpdateDetails) onPanUpdate;
  final void Function() onPanEnd;

  const DockIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.isDragging,
    required this.dragOffsetX,
    required this.calculateScale,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    const itemWidth = Dimens.itemSize;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: Dimens.duration),
      curve: Curves.easeInOut,
      left: isDragging ? dragOffsetX : index * itemWidth + 15,
      top: 15 - (calculateScale(index) - 1) * 20, // Adjust height dynamically.
      child: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: (_) => onPanEnd(),
        child: Transform.scale(
          scale: isDragging ? Dimens.opacityHigh : calculateScale(index), // Smooth scaling.
          child: Opacity(
            opacity: isDragging ? Dimens.opacityMid : Dimens.opacityReg,
            child: Container(
              width: Dimens.width,
              height: Dimens.height,
              margin: const EdgeInsets.all(Dimens.margin_8),
              decoration: BoxDecoration(
                color: Colors.primaries[icon.hashCode % Colors.primaries.length],
                borderRadius: BorderRadius.circular(Dimens.radius_12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
