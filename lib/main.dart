import 'package:dragdrop/app/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'app/widgets/dock_icon.dart';

void main() {
  runApp(const MyApp());
}

/// Main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: double.infinity,
            height: Dimens.sizeBox,
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

/// Dock widget with Apple-like scaling effect.
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
        borderRadius: BorderRadius.circular(Dimens.radius_8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(Dimens.pad_8),
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(_icons.length, _buildAnimatedIcon),
      ),
    );
  }

  /// Builds an animated icon with scaling effect.
  Widget _buildAnimatedIcon(int index) {
    return DockIcon(
      icon: _icons[index],
      index: index,
      isDragging: _draggingIndex == index,
      dragOffsetX: _dragOffsetX,
      calculateScale: _calculateScale,
      onPanStart: (details) {
        setState(() {
          _draggingIndex = index;
          _dragOffsetX = index * Dimens.itemSize;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _dragOffsetX += details.delta.dx;
          _swapItems();
        });
      },
      onPanEnd: () {
        setState(() {
          _draggingIndex = null;
          _dragOffsetX = 0.0;
        });
      },
    );
  }

  /// Calculates the scaling factor for icons.
  double _calculateScale(int index) {
    if (_draggingIndex == null) return 1.0;
    final distance = (_dragOffsetX - index * Dimens.itemSize).abs();
    return (1.5 - distance / Dimens.itemSize).clamp(1.0, 1.5);
  }

  /// Swaps items based on drag position.
  void _swapItems() {
    if (_draggingIndex == null) return;
    int newIndex =
        (_dragOffsetX / Dimens.itemSize).round().clamp(0, _icons.length - 1);

    if (newIndex != _draggingIndex) {
      setState(() {
        final item = _icons.removeAt(_draggingIndex!);
        _icons.insert(newIndex, item);
        _draggingIndex = newIndex;
      });
    }
  }
}
