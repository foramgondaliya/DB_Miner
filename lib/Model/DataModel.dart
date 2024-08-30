class Quote {
  int? id;
  String quote;
  String author;

  Quote({
    this.id,
    required this.quote,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
    };
  }

  factory Quote.fromMap({required Map data}) {
    return Quote(
      id: data['id'],
      quote: data['quote'],
      author: data['author'],
    );
  }
}
