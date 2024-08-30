import 'package:budget_tracker_app/Model/DataModel.dart';
import 'package:budget_tracker_app/helper/db_Helper.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final Set<String> favoriteQuotes = {};

  @override
  Widget build(BuildContext context) {
    final dynamic quote = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes"),
      ),
      body: ListView.builder(
        itemCount: quote.length,
        itemBuilder: (context, index) {
          final quoteData = quote[index];
          final isFavorite = favoriteQuotes.contains(quoteData['quote']);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://i.pinimg.com/564x/ac/34/1a/ac341a47f72d15ad6410886ab30b7f06.jpg",
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: 750,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quoteData['quote'],
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "- ${quoteData['author']}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (!isFavorite) {
                              final newQuote = Quote(
                                quote: quoteData['quote'],
                                author: quoteData['author'],
                              );
                              await dbHelper.insertQuote(newQuote);
                              setState(() {
                                favoriteQuotes.add(quoteData['quote']);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to favourites'),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 40,
                            color: isFavorite ? Colors.red : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              'EditPage',
                              arguments: {
                                'quote': quoteData['quote'],
                                'author': quoteData['author'],
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
