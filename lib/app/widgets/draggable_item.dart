import 'package:flutter/material.dart';
import '../utils/dimens.dart';

class DraggableItem<T extends Object> extends StatelessWidget {
  final T item;
  final Widget Function(T item) builder;
  final Function(T draggedItem, int index) onUpdateItemsOrder;
  final int index;

  const DraggableItem({
    super.key,
    required this.item,
    required this.builder,
    required this.onUpdateItemsOrder,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<T>(
      data: item,
      axis: Axis.horizontal,
      feedback: Material(
        child: Opacity(
          opacity: Dimens.opacityMid,
          child: builder(item),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: Dimens.opacityReg,
        child: builder(item),
      ),
      child: DragTarget<T>(
        onMove: (details) {
          final draggedItem = details.data;
          if (draggedItem != item) {
            onUpdateItemsOrder(draggedItem, index);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: Dimens.duration),
            child: builder(item),
          );
        },
      ),
    );
  }
}
