import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final PageController _pageController;
  final int _page;

  DrawerTile(this._icon, this._text, this._pageController, this._page);

  Color _getColor(BuildContext context) {
    return _pageController.page.round() == _page
        ? Theme.of(context).primaryColorDark
        : Colors.blueGrey[800];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _pageController.jumpToPage(_page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                _icon,
                size: 32.0,
                color: _getColor(context),
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                _text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _getColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
