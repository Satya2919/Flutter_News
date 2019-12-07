import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final img;
  final _title;
  final _date;
  final _description;

  Detail(this.img, this._title, this._date, this._description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Material(
            elevation: 4.0,
            borderRadius: new BorderRadius.circular(16.0),
            child: new ListView(
              children: <Widget>[
                new Hero(tag: _title, child: _getImageNetwork(img)),
                _getBody(_title, _date, _description),
              ],
            ),
          ),
        ));
  }

  Widget _getImageNetwork(url) {
    try {
      if (url != '') {
        return ClipRRect(
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0)),
          child: new Container(
            height: 200.0,
            child: new FadeInImage.assetNetwork(
              placeholder: 'assets/place_holder.jpg',
              image: url,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return new Container(
          height: 200.0,
          child: new Image.asset('assets/place_holder_3.jpg'),
        );
      }
    } catch (e) {
      return new Container(
        height: 200.0,
        child: new Image.asset('assets/place_holder_3.jpg'),
      );
    }
  }

  _getBody(title, date, description) {
    return new Container(
        margin: new EdgeInsets.all(15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getTitle(_title),
            _getDate(_date),
            _getDescription(description),
          ],
        ));
  }

  _getTitle(title) {
    return new Text(
      title,
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    );
  }

  _getDate(date) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: new Text(
          date,
          style: new TextStyle(fontSize: 10.0, color: Colors.grey),
        ));
  }

  _getDescription(description) {
    return new Container(
      margin: new EdgeInsets.only(top: 20.0),
      child: new Text(description),
    );
  }
}
