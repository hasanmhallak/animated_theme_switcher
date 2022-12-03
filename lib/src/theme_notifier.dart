import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ThemeConfig extends ChangeNotifier {
  late final AnimationController controller;

  late ThemeData _selectedTheme;
  late ThemeData _otherTheme;
  ThemeData get theme => _selectedTheme;
  ThemeData get otherTheme => _otherTheme;

  late bool isReversed;
  bool didEverChange = false;

  Offset switcherOffset = Offset.zero;

  late final GlobalKey screenShotKey;
  late final GlobalKey switcherKey;

  ui.Image? screenShot;

  bool _isInit = false;

  void init({
    required ThemeData light,
    required ThemeData dark,
    required Brightness deviceBrightness,
    required AnimationController controller,
    required GlobalKey screenShotKey,
    required GlobalKey switcherKey,
  }) {
    if (deviceBrightness == Brightness.light) {
      _selectedTheme = light;
      _otherTheme = dark;
      isReversed = true;
    } else {
      _selectedTheme = dark;
      _otherTheme = light;
      isReversed = false;
    }
    this.controller = controller;
    this.screenShotKey = screenShotKey;
    this.switcherKey = switcherKey;

    _isInit = true;
  }

  Future<void> changeTheme() async {
    assert(_isInit, 'Must Call init first.');

    if (controller.isAnimating) {
      return;
    }

    final ThemeData oldTheme = _selectedTheme;
    _selectedTheme = _otherTheme;
    _otherTheme = oldTheme;
    // bool isReversed = this.isReversed;

    switcherOffset = _getSwitcherCoordinates(switcherKey);
    await _saveScreenshot(screenShotKey);
    didEverChange = true;
    isReversed = !isReversed;
    notifyListeners();

    if (isReversed) {
      await controller.reverse(from: 1);
    } else {
      await controller.forward(from: 0);
    }
  }

  Future<void> _saveScreenshot(GlobalKey screenShotKey) async {
    // ignore: cast_nullable_to_non_nullable
    final boundary = screenShotKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    screenShot = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
  }

  Offset _getSwitcherCoordinates(GlobalKey switcherGlobalKey) {
    final renderObject =
        switcherGlobalKey.currentContext!.findRenderObject()! as RenderBox;
    final size = renderObject.size;
    return renderObject.localToGlobal(Offset(size.width / 2, size.height / 2));
  }
}
