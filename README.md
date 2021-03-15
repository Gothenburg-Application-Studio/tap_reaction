# Tap Reaction

A flutter plugin made to simplify adding visual feedback when a button is pressed.

There are currently two types of animations availible, `TapReaction.scale()` and `TapReaction.fade()`:

![Two buttons showing a preview of the animations](https://i.imgur.com/DhpH8o9.mp4)

## Usage

To add visual feedback to any widget, simply wrap it in the `TapReaction.scale()` or `TapReaction.fade()` widget. This
widget is fully transparant and won't affect any other widgets that need to recieve the tap (or another gesture).

### Example

```
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
```

For a full example see [the example tab](https://pub.dev/packages/tap_reaction/example) or [the GitHub repository](https://github.com/Gothenburg-Application-Studio/tap_reaction/blob/master/example/lib/main.dart).

## Known issues

* The original material design ripple effect is visible even if you use this plugin to get another effect. I have not found a way to disable this for all possible child widgets, and have therefore left that to the user of this plugin. Pull requests are welcome if anyone has a solution.