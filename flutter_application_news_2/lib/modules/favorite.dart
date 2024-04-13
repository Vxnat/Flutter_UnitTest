// ignore_for_file: public_member_api_docs, sort_constructors_first
class Favorite {
  String? title;
  String? author;
  String? name;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Favorite({
    this.title,
    this.author,
    this.name,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  String toString() {
    return '$title|$author|$name|$urlToImage|$publishedAt|$content';
  }

  // Reconstruct a Note object from a string
  factory Favorite.fromString(String noteString) {
    List<String> parts = noteString.split('|');
    return Favorite(
      title: parts[0],
      author: parts[1],
      name: parts[2],
      urlToImage: parts[3],
      publishedAt: parts[4],
      content: parts[5],
    );
  }
}
