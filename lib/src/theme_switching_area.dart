import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider.dart';
import 'theme_clipper.dart';

class ThemeSwitchingArea extends ConsumerWidget {
  ThemeSwitchingArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  //one more key to save drawer state
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeProvider);
    Widget child = this.child;
    if (!themeConfig.didEverChange) {
      child = _getPage(themeConfig.theme);
    } else {
      late final Widget firstWidget;
      late final Widget animWidget;

      if (themeConfig.isReversed) {
        firstWidget = _getPage(themeConfig.theme);
        animWidget = RawImage(image: themeConfig.screenShot);
      } else {
        firstWidget = RawImage(image: themeConfig.screenShot);
        animWidget = _getPage(themeConfig.theme);
      }

      child = Stack(
        alignment: Alignment.center,
        children: [
          Container(
            key: const ValueKey('first'),
            child: firstWidget,
          ),
          AnimatedBuilder(
            key: const ValueKey('second'),
            animation: themeConfig.controller,
            child: animWidget,
            builder: (_, child) {
              return ClipPath(
                clipper: OvalClipper(
                  themeConfig.controller.value,
                  themeConfig.switcherOffset,
                ),
                child: child,
              );
            },
          ),
        ],
      );
    }

    return Material(child: child);
  }

  Widget _getPage(ThemeData brandTheme) {
    return Theme(
      key: _globalKey,
      data: brandTheme,
      child: child,
    );
  }
}
