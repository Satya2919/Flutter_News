import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:news_final/database/recent_dao.dart';
import 'package:news_final/models/recent.dart';
import 'package:news_final/news_bloc/bloc.dart';
import 'package:news_final/notice.dart';

import 'models/news.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(),
      child: MaterialApp(
        home: new SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/HomePage': (BuildContext context) => new HomePage()
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }
  
  void navigationPage(){
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: Image.asset('assets/images/custom.png'),
      ),
      
    );
  }
}





class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _newsBloc.add(LoadNews('flutter'));
  }

  @override
  void dispose() {
    _newsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Monk'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearch(),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return BlocBuilder(
      bloc: _newsBloc,
      builder: (BuildContext context, NewsState state) {
        if (state is NewsLoading) {
          // _newsBloc.add(LoadNews('flutter'));
          return Center(
            child: Loading(
              indicator: BallPulseIndicator(),
              size: 100.0,
              color: Colors.grey,
            ),
          );
        } else if (state is NewsLoaded) {
          return ListView.builder(
            itemCount: state.newsList.length,
            itemBuilder: (BuildContext context, int index) {
              News news = state.newsList[index];
              return Notice(
                newsDate: news.publishedAt,
                newsDescription: news.description,
                newsTitle: news.title,
                imgUrl: news.urlToImage,
              );
            },
          );
        } else {
          return Center(
            child: Text('Im Screwed up'),
          );
        }
      },
    );
  }
}

class NewsSearch extends SearchDelegate<String> {
  List<String> defaultSearch = [
    'latest',
    'india',
    'technology',
    'android',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    NewsBloc _newsBloc = BlocProvider.of<NewsBloc>(context);
    _newsBloc.add(LoadNews(query));
    return BlocBuilder(
      bloc: _newsBloc,
      builder: (BuildContext context, NewsState state) {
        if (state is NewsLoading) {
          _newsBloc.add(LoadNews(query));
          return Center(
            child: Loading(
              indicator: BallPulseIndicator(),
              size: 100.0,
              color: Colors.grey,
            ),
          );
        } else if (state is NewsLoaded) {
          // _newsBloc.close();
          return ListView.builder(
            itemCount: state.newsList.length,
            itemBuilder: (BuildContext context, int index) {
              News news = state.newsList[index];
              return Notice(
                newsDate: news.publishedAt,
                newsDescription: news.description,
                newsTitle: news.title,
                imgUrl: news.urlToImage,
              );
            },
          );
        } else {
          return Center(
            child: Text('Im Screwed up'),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final RecentDao _recentDao = RecentDao();
    return FutureBuilder(
      future: _recentDao.getAllRecent(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot == null || snapshot.data == null) {
          return ListTile(
            leading: Icon(Icons.chrome_reader_mode),
            title: Text(query),
          );
        }
        List<Recent> userRecent = snapshot.data;
        List<String> userSearch = List<String>();
        userRecent.forEach((item) {
          userSearch.add(item.topic);
        });
        userRecent.clear();
        final suggestionList = query.isEmpty
            ? defaultSearch
            : userSearch.where((item) => item.startsWith(query)).toList();
        return ListView.builder(
          itemCount: suggestionList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(Icons.chrome_reader_mode),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.call_made),
              onTap: () {
                query = suggestionList[index];
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
