import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/post/post_cubit.dart';
import '../cubit/post/post_state.dart';
import '../repositories/post_repository.dart';

class PostDetailPage extends StatelessWidget {
  final int postId;

  PostDetailPage({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => PostCubit(
            postRepository: RepositoryProvider.of<PostRepository>(context))
          ..fetchPostComments(postId),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostWithCommentsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.post.title,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.post.body,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Comments',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.comments[index].name),
                          subtitle: Text(state.comments[index].body),
                        );
                      },
                    ),
                  ],
                ),
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
