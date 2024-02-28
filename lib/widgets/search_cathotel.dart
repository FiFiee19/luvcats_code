import 'package:flutter/material.dart';
import 'package:luvcats_app/features/cathotel/screens/detail_cathotel.dart';
import 'package:luvcats_app/models/cathotel.dart';

class CathotelSearchDelegate extends SearchDelegate<Cathotel?> {
  final List<Cathotel> cathotels;

  CathotelSearchDelegate({required this.cathotels});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = cathotels.where((cathotel) {
      return cathotel.user!.username
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(result.user!.imagesP),
          ),
          title: Text(result.user!.username),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCathotelScreen(cathotel: result),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
