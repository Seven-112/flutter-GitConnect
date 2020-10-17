import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  final String title, description;
  final IconData icon;
  final String image;
  const NoDataPage({Key key, this.image, this.title, this.description, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image != null ? Image.asset(image, width: 160) : Icon(icon, size: 120),
            SizedBox(height: 16),
            if (title != null && title.isNotEmpty)
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 8),
            if (description != null && description.isNotEmpty)
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
