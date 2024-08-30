import 'package:budget_tracker_app/Model/DataModel.dart';
import 'package:budget_tracker_app/helper/db_Helper.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Quote>> favourites;

  @override
  void initState() {
    super.initState();
    favourites = dbHelper.retrieveQuotes();
  }

  Future<void> removeQuote(int id) async {
    await dbHelper.deleteQuote(id);
    setState(() {
      favourites = dbHelper.retrieveQuotes();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed from favourites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favourite Quotes",
        ),
      ),
      body: FutureBuilder<List<Quote>>(
        future: favourites,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favourites yet'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final quote = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('DetailPage', arguments: quote);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          quote.quote,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '- ${quote.author}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => removeQuote(quote.id!),
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
