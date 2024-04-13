// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comment {
  String title;
  String content;
  String time;
  String avatarUrl;
  Comment({
    required this.title,
    required this.content,
    required this.time,
    required this.avatarUrl,
  });

  @override
  String toString() {
    return '$title|$content|$time|$avatarUrl';
  }

  // Reconstruct a Note object from a string
  factory Comment.fromString(String noteString) {
    List<String> parts = noteString.split('|');
    return Comment(
      title: parts[0],
      content: parts[1],
      time: parts[2],
      avatarUrl: parts[3],
    );
  }
}
