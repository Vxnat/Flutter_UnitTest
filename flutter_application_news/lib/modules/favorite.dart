// ignore_for_file: public_member_api_docs, sort_constructors_first
class Favorite {
  int? id;
  String? title;
  String? author;
  String? name;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Favorite({
    this.id,
    this.title,
    this.author,
    this.name,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  String toString() {
    return '$id|$title|$author|$name|$urlToImage|$publishedAt|$content';
  }

  // Reconstruct a Note object from a string
  factory Favorite.fromString(String noteString) {
    List<String> parts = noteString.split('|');
    return Favorite(
      id: int.parse(parts[0]),
      title: parts[1],
      author: parts[2],
      name: parts[3],
      urlToImage: parts[4],
      publishedAt: parts[5],
      content: parts[6],
    );
  }

  // factory Favorite.fromJson(Map<String, dynamic> json) {
  //   return Favorite(
  //     title: json['title'],
  //     name: json['source']['name'],
  //     urlToImage: json['urlToImage'],
  //     publishedAt: json['publishedAt'],
  //     content: json['content'],
  //     timeRead: '',
  //   );
  // }
}
