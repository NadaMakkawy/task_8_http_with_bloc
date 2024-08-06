import 'package:bloc/bloc.dart';
import '../../repositories/post_repository.dart';

import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;

  PostCubit({required this.postRepository}) : super(PostInitial());

  void fetchPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepository.fetchPosts();
      emit(PostsLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void fetchPostComments(int postId) async {
    try {
      emit(PostLoading());
      final post = await postRepository.fetchPost(postId);
      final comments = await postRepository.fetchComments(postId);
      emit(PostWithCommentsLoaded(post: post, comments: comments));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void toggleLikePost(int postId) {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == postId) {
          final updatedLikes = post.liked ? post.likes - 1 : post.likes + 1;
          return post.copyWith(likes: updatedLikes, liked: !post.liked);
        }
        return post;
      }).toList();
      emit(PostsLoaded(posts: updatedPosts));
    }
  }
}
