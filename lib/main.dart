/// LINK TO ANOTHER APPROACH WITHOUT STATE MANAGEMENT PACKAGES
/// https://github.com/NadaMakkawy/task_8_http_without_bloc.git

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home_page.dart';
import 'repositories/post_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PostRepository postRepository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: postRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Posts with Cubit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
