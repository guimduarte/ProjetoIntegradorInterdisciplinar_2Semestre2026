import 'package:flutter/material.dart';
import '../theme/tema_do_app.dart';

/// Círculo com ícone representando uma categoria de serviço manual
/// (pedreiro, carpinteiro, pintor, eletricista, técnico e encanador) na tela inicial.
class ItemCategoria extends StatefulWidget {
  final IconData icon;
  final String texto;
  final Color background;
  final Color iconColor;
  final VoidCallback? onTap;
  final double scale;

  const ItemCategoria({
    super.key,
    required this.icon,
    required this.texto,
    required this.background,
    required this.iconColor,
    this.onTap,
    this.scale = 1.0,
  });

  @override
  State<ItemCategoria> createState() => _ItemCategoriaState();
}

class _ItemCategoriaState extends State<ItemCategoria>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.18, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;
    await _controller.forward(from: 0);
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final double containerSize = 52 * widget.scale;
    final double iconSize = 24 * widget.scale;
    final double fontSize = (11 * widget.scale).clamp(8.0, 11.0);
    final double spacing = 6 * widget.scale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Círculo: aqui fica o InkWell com ripple, clipado no formato circular
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _handleTap,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) =>
                  Transform.scale(scale: _pulseAnimation.value, child: child),
              child: Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  color: widget.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: iconSize),
              ),
            ),
          ),
        ),
        SizedBox(height: spacing),
        // Label: área de toque separada, sem ripple
        GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            widget.texto,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize, color: CoresApp.textoPrimario),
          ),
        ),
      ],
    );
  }
}