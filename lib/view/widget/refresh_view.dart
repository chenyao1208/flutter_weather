import 'package:flutter_weather/commom_import.dart';

class RefreshView extends StatefulWidget {
  final Widget child;

  RefreshView({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  State createState() => RefreshState(child: child);
}

/// 带有圆形加载进度条的Stack
class RefreshState extends State<RefreshView> with TickerProviderStateMixin {
  final Widget child;

  AnimationController _controller;
  Animation<Size> _animation;

  RefreshState({@required this.child});

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = SizeTween(begin: Size(50, 50), end: Size.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    dismiss();
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicator = RefreshProgressIndicator();

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        child,
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: AnimatedBuilder(
            animation: _animation,
            child: indicator,
            builder: (context, child) {
              return Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                child: Container(
                  height: _animation.value.height,
                  width: _animation.value.width,
                  child: indicator,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 显示加载进度条
  void show() {
    _controller.reset();
  }

  /// 隐藏进度条
  void dismiss() {
    _controller.forward();
  }
}
