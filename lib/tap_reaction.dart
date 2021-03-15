library tap_reaction;

import 'package:flutter/material.dart';

/// A widget that animates it child when it is pressed.
///
/// To avoid false positives, the animation starts when the pointer is removed
/// from the screen. The same is true for the [InkWell] widget. This means that
/// the animation will start at the same time as an `onTap` in an [InkWell] or
/// an `onPressed` event in an [ElevatedButton].
class TapReaction extends StatefulWidget {
  /// Animates its child using a scale animation.
  ///
  /// More specifically it uses the [Transform.scale()] widget with the `scale`
  /// comes from an animation controller.
  const TapReaction.scale({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 120),
    this.curve = Curves.easeInCubic,
    double endScale = 0.95,
  })  : animationValue = endScale,
        animationType = AnimationType.scale,
        super(key: key);

  /// Animates its child using a opacity animation.
  ///
  /// More specifically it uses the [Opacity] widget with the `opacity`
  /// comes from an animation controller.
  const TapReaction.fade({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 120),
    this.curve = Curves.easeInOutCubic,
    double minOpacity = 0.5,
  })  : assert(minOpacity >= 0 && minOpacity <= 1),
        animationValue = minOpacity,
        animationType = AnimationType.fade,
        super(key: key);

  /// The Widget that will react to a tap.
  final Widget child;

  /// Defines how much the widget will be animated.
  ///
  /// This value is specified either via endOpacity or endScale and
  /// must be a value between 1 (no effect) and 0 if [animationType]
  /// is [AnimationType.fade].
  final double animationValue;

  /// The type of animation.
  ///
  /// Eihter `scale` or `fade`. Is specified via the [TapReaction.fade()] or
  /// [TapReaction.scale()] constructor
  final AnimationType animationType;

  // The duration of the animation.
  final Duration duration;

  /// Animation curve
  final Curve curve;

  @override
  _TapReactionState createState() => _TapReactionState();
}

class _TapReactionState extends State<TapReaction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  /// The treshold for when the pointer event should be seen as a scrolling motion.
  final double _scrollTreshold = 0.2;

  /// Whether the pointer event is a scrolling motion or not
  ///
  /// If the pointer movement is above the `_scrollTreshold` the pointer event
  /// will be seen as a scrolling motion.
  bool _isScroll = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 1, end: widget.animationValue).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _controller,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        // Go back to original state.
        if (status == AnimationStatus.completed) _controller.reverse();
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A GestureDetector does not work here since the controller must be
    // animated even if another tap wins in the gesture arena.
    return Listener(
      // Reset variables on a new press.
      onPointerDown: (_) {
        _isScroll = false;
      },
      onPointerMove: (event) {
        // Notify the rest of the widget that this is a scrolling motion.
        if (event.delta.dy.abs() > _scrollTreshold ||
            event.delta.dy.abs() > _scrollTreshold) {
          _isScroll = true;
        }
      },
      onPointerUp: (_) {
        if (!_isScroll) {
          _controller.forward();
        }
      },
      child: widget.animationType == AnimationType.scale
          ? Transform.scale(
              scale: _animation.value,
              child: widget.child,
            )
          : Opacity(
              opacity: _animation.value,
              child: widget.child,
            ),
    );
  }
}

enum AnimationType {
  fade,
  scale,
}
