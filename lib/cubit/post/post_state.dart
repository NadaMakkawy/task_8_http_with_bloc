import '../../models/post.dart';
import '../../models/comment.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<Post> posts;

  PostsLoaded({required this.posts});
}

class PostWithCommentsLoaded extends PostState {
  final Post post;
  final List<Comment> comments;

  PostWithCommentsLoaded({required this.post, required this.comments});
}

class PostError extends PostState {
  final String message;

  PostError({required this.message});
}
