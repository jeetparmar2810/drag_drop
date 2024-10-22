import 'package:dragdrop/app/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'app/widgets/dock_icon.dart';

void main() {
  runApp(const MyApp());
}

/// The main widget that initializes the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: double.infinity,
            height: Dimens.dockHeight,
            child: Dock(
              items: [
                Icons.person,
                Icons.message,
                Icons.call,
                Icons.camera,
                Icons.photo,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that creates an Apple Dock-like effect with draggable icons.
class Dock extends StatefulWidget {
  const Dock({super.key, required this.items});

  final List<IconData> items;

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  late final List<IconData> _icons = List.of(widget.items);
  int? _draggingIndex;
  double _dragOffsetX = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.borderRadiusSmall),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(Dimens.paddingSmall),
      child: Stack(
        children: List.generate(_icons.length, _buildAnimatedIcon),
      ),
    );
  }

  /// Creates a draggable and animated icon widget.
  Widget _buildAnimatedIcon(int index) {
    return DockIcon(
      icon: _icons[index],
      index: index,
      isDragging: _draggingIndex == index,
      dragOffsetX: _dragOffsetX,
      scaleFactor: _calculateScale,
      onStart: (details) {
        setState(() {
          _draggingIndex = index;
          _dragOffsetX = index * Dimens.iconSize;
        });
      },
      onUpdate: (details) {
        setState(() {
          _dragOffsetX += details.delta.dx;
          _swapItems();
        });
      },
      onEnd: () {
        setState(() {
          _draggingIndex = null;
          _dragOffsetX = 0.0;
        });
      },
    );
  }

  /// Calculates the scaling factor for the icons based on proximity to the drag point.
  double _calculateScale(int index) {
    if (_draggingIndex == null) return 1.0;
    final distance = (_dragOffsetX - index * Dimens.iconSize).abs();
    return (1.5 - distance / Dimens.iconSize).clamp(1.0, 1.5);
  }

  /// Swaps the positions of icons based on the current drag offset.
  void _swapItems() {
    if (_draggingIndex == null) return;

    final newIndex = (_dragOffsetX / Dimens.iconSize)
        .round()
        .clamp(0, _icons.length - 1);

    if (newIndex != _draggingIndex) {
      setState(() {
        final item = _icons.removeAt(_draggingIndex!);
        _icons.insert(newIndex, item);
        _draggingIndex = newIndex;
      });
    }
  }
}