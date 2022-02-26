import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshIndicatorWidget extends StatefulWidget {
  const RefreshIndicatorWidget({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.margin = 0.0,
  }) : super(key: key);

  final Widget child;
  final Future<void> Function() onRefresh;
  final double margin;

  @override
  State<RefreshIndicatorWidget> createState() => _RefreshIndicatorWidgetState();
}

class _RefreshIndicatorWidgetState extends State<RefreshIndicatorWidget> {
  double progress = 0;

  final controller = RefreshController();
  final height = 60.0;

  late final centerMargin = EdgeInsets.only(bottom: widget.margin);

  /// Previous status of refresh widget.
  ///
  /// Used to manage vibration, cause phone should vibrate only when
  /// canRefresh status appears after idle.
  late RefreshStatus? previousMode = RefreshStatus.idle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      onRefresh: () => widget.onRefresh().then(
            (value) => controller.refreshCompleted(),
          ),
      header: CustomHeader(
        height: height,
        onOffsetChange: (offset) => setState(() => progress = offset * .75),
        builder: (context, mode) {
          if (mode == RefreshStatus.canRefresh &&
              previousMode == RefreshStatus.idle) {
            //Vibrate.heavy();
          }

          previousMode = mode;
          if (mode == RefreshStatus.idle) {
            return Container(
              margin: centerMargin,
              child: CupertinoActivityIndicator.partiallyRevealed(
                progress: (progress / height).clamp(0.0, 1.0),
                radius: 12,
              ),
            );
          } else {
            return Container(
              margin: centerMargin,
              child: const CupertinoActivityIndicator(radius: 12),
            );
          }
        },
      ),
      child: widget.child,
    );
  }
}
