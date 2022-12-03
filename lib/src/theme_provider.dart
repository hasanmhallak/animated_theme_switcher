import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider.dart';
import 'theme_notifier.dart';

typedef ThemeBuilder = Widget Function(BuildContext, ThemeData theme);

class ThemeProvider extends StatefulWidget {
  final ThemeBuilder builder;
  final Duration duration;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ProviderContainer? container;
  const ThemeProvider({
    Key? key,
    required this.builder,
    required this.lightTheme,
    required this.darkTheme,
    this.duration = const Duration(seconds: 1),
    this.container,
  }) : super(key: key);
  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    final deviceBrightness =
        SchedulerBinding.instance.window.platformBrightness;

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    themeProvider = ChangeNotifierProvider<ThemeConfig>((ref) {
      return ThemeConfig()
        ..init(
          light: widget.lightTheme,
          dark: widget.darkTheme,
          deviceBrightness: deviceBrightness,
          controller: controller,
          screenShotKey: GlobalKey(),
          switcherKey: GlobalKey(),
        );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: widget.container ?? ProviderContainer(),
      child: Consumer(builder: (context, ref, _) {
        final themeConfig = ref.watch(themeProvider);
        return RepaintBoundary(
          key: themeConfig.screenShotKey,
          child: widget.builder(context, themeConfig.theme),
        );
      }),
    );
  }
}
