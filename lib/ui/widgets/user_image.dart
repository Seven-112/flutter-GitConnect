import 'package:flutter/material.dart';
import 'package:flutter_github_connect/helper/GIcons.dart';
import 'package:flutter_github_connect/ui/widgets/cached_image.dart';

import "package:build_context/build_context.dart";

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    this.imagePath,
    this.name,
    this.subtitle,
    this.height = 20,
    this.titleStyle,
    this.subTitleStyle,
  }) : super(key: key);
  final String imagePath;
  final String name, subtitle;
  final double height;
  final TextStyle titleStyle;
  final TextStyle subTitleStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          imagePath == null
              ? Container(
                  height: height,
                  width: height,
                  alignment: Alignment.center,
                  child:
                      Icon(GIcons.github, size: height < 25 ? 13 : height - 10),
                )
              : Avatar(imagePath: imagePath,height: height,),
          SizedBox(width: name == null && subtitle == null ? 0 : height / 4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              name == null ? SizedBox.shrink() : SizedBox(width: 10),
              name == null
                  ? SizedBox.shrink()
                  : Text(name,
                      style: titleStyle ?? context.textTheme.bodyText1),
              subtitle == null
                  ? SizedBox.shrink()
                  : name == null
                      ? SizedBox.shrink()
                      : SizedBox(height: height > 30 ? 10 : 0),
              subtitle == null
                  ? SizedBox.shrink()
                  : Text(subtitle,
                      style: subTitleStyle ?? context.textTheme.subtitle2),
            ],
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.imagePath, this.height}) : super(key: key);
  final String imagePath;
  final double height;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 4.8),
      child: customNetworkImage(
        imagePath,
        height: height,
        placeholder: Container(
          height: height,
          width: height,
          alignment: Alignment.center,
          child: Icon(GIcons.github, size: height < 25 ? 13 : height - 10),
        ),
      ),
    );
  }
}
