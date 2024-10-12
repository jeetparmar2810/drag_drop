import 'package:dragdrop/app/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'app/widgets/draggable_item.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Widget that builds the MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Dock',
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon) {
              return Container(
                constraints: const BoxConstraints(minWidth:  Dimens.height,),
                height: Dimens.height,
                margin: const EdgeInsets.all(Dimens.margin_8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.margin_8),
                  color: Colors.primaries[icon.hashCode % Colors.primaries.length],
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A Dock widget that allows reordering of items.
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial items to put in this Dock.
  final List<T> items;

  /// Builder that creates a widget for each item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the Dock used to manipulate the items.
class _DockState<T extends Object> extends State<Dock<T>> {
  late final List<T> _dockerItems = List.from(widget.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(Dimens.margin_8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_dockerItems.length, (index) {
          return _buildItem(index);
        }),
      ),
    );
  }

  /// Creates a draggable item for the Dock.
  Widget _buildItem(int index) {
    final item = _dockerItems[index];
    return DraggableItem<T>(
      item: item,
      builder: widget.builder,
      onUpdateItemsOrder: (draggedItem, index) {
        setState(() {
          _updateDockerItemsOrder(draggedItem, index);
        });
      },
      index: index,
    );
  }

  /// Updates the order of items when dragging.
  void _updateDockerItemsOrder(T draggedItem, int targetIndex) {
    final oldIndex = _dockerItems.indexOf(draggedItem);
    _dockerItems.removeAt(oldIndex);
    _dockerItems.insert(targetIndex, draggedItem);
  }
}