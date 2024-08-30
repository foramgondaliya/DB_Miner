import 'dart:convert';
import 'package:budget_tracker_app/Model/DataModel.dart';
import 'package:budget_tracker_app/helper/api_Helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> response;

  Future<Map<String, dynamic>> loadQuotes() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> data =
        json.decode(jsonString) as Map<String, dynamic>;
    return data;
  }

  @override
  void initState() {
    super.initState();
    response = loadQuotes();
  }

  void showRandomQuote() async {
    final Quote? randomQuote = await ApiHelper.apiHelper.fetchRandomQuote();
    if (randomQuote != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Random Quote"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  randomQuote.quote,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "- ${randomQuote.author}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Categories'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('FavouritePage');
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton(
          onPressed: showRandomQuote,
          child: const Text("Surprise me"),
          isExtended: true,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final categories = snapshot.data!.keys.toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final categoryName = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('DetailPage',
                        arguments: snapshot.data![categoryName]);
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          categoryName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
