import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/post/post_state.dart';
import '../cubit/post/post_cubit.dart';
import '../repositories/post_repository.dart';
import '../widgets/post_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POSTS'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => PostCubit(
            postRepository: RepositoryProvider.of<PostRepository>(context))
          ..fetchPosts(),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostsLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return PostItem(post: post);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is PostError) {
              return Center(child: Text(state.message));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
