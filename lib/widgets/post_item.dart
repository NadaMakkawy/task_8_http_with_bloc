import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/post/post_cubit.dart';
import '../cubit/post/post_state.dart';
import '../models/post.dart';
import '../pages/post_detail_page.dart';

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _showComments = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PostDetailPage(
                  postId: widget.post.id,
                ),
              ));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.post.body),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${widget.post.id}@gmail.com • ${DateTime.now().toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _showComments = !_showComments;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PostDetailPage(
                                    postId: widget.post.id,
                                  ),
                                ));

                            if (_showComments) {
                              context
                                  .read<PostCubit>()
                                  .fetchPostComments(widget.post.id);
                            }
                          },
                        ),
                        const SizedBox(width: 4),
                        const Text('0', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            widget.post.liked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.liked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            context
                                .read<PostCubit>()
                                .toggleLikePost(widget.post.id);
                          },
                        ),
                        const SizedBox(width: 4),
                        Text('${widget.post.likes}',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                if (_showComments) _buildComments(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComments(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostWithCommentsLoaded &&
            state.post.id == widget.post.id) {
          if (state.comments.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Text('No comments', style: TextStyle(color: Colors.grey)),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Column(
              children: state.comments.map((comment) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.name,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(comment.body),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (state is PostWithCommentsLoaded) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
  }
}
