class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  final int likes;
  final bool liked;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.likes = 0,
    this.liked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
      likes: 0,
      liked: false,
    );
  }

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    int? likes,
    bool? liked,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
    );
  }
}
