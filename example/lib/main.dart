import 'package:flutter/material.dart';
import 'package:tap_reaction/tap_reaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TapReaction.scale(
                endScale: 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    print('Animating button scale');
                  },
                  child: Text(
                    'Scale',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TapReaction.fade(
                minOpacity: 0.2,
                child: ElevatedButton(
                  onPressed: () {
                    print('Animating button opacity');
                  },
                  child: Text(
                    'Fade',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
