
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DotLoadingWidget extends StatelessWidget {
  final double size;
  const DotLoadingWidget({Key? key,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
        child: LoadingAnimationWidget.inkDrop(
          size: size,
          color: theme.canvasColor,
        ),
    );
  }
}
