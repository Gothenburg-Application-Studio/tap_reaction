import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_reaction/tap_reaction.dart';

void main() {
  testWidgets('TapReaction.scale() scales to endScale and back in duration', (WidgetTester tester) async {
    await tester.pumpWidget(
      TapReaction.scale(
        child: Container(
          width: 100,
          height: 100,
        ),
      ),
    );

    Finder _findByWidth(double scale, String description) {
      return find.byWidgetPredicate(
        (Widget widget) {
          if (widget is Transform) {
            Matrix4 transform = widget.transform;
            print(transform.toString());
            return (transform == Matrix4.diagonal3Values(scale, scale, 1.0));
          } else {
            return false;
          }
        },
        description: description,
      );
    }

    expect(
      _findByWidth(1, 'Scale of child widget is 1 at first'),
      findsOneWidget,
    );

    await tester.tap(find.byType(TapReaction));

    // setState after half the animation
    await tester.pump(Duration(milliseconds: 60));

    expect(
      _findByWidth(0.95, 'Scale of child widget is 0.95 after half the duration'),
      findsOneWidget,
    );

    await tester.pumpAndSettle();

    expect(
      _findByWidth(1, 'Scale of child widget is 1 when animation is finished'),
      findsOneWidget,
    );
  });
}
