// ignore_for_file: public_member_api_docs, sort_constructors_first
class Favorite {
  String? title;
  String? name;
  String? urlToImage;
  String? publishedAt;
  String? content;
  String? timeRead;

  Favorite({
    this.title,
    this.name,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.timeRead,
  });

  @override
  String toString() {
    return '$title|$name|$urlToImage|$publishedAt|$content|$timeRead';
  }

  // Reconstruct a Note object from a string
  factory Favorite.fromString(String noteString) {
    List<String> parts = noteString.split('|');
    return Favorite(
        title: parts[0],
        name: parts[1],
        urlToImage: parts[2],
        publishedAt: parts[3],
        content: parts[4],
        timeRead: parts[5]);
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      title: json['title'],
      name: json['source']['name'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      timeRead: '',
    );
  }
}
