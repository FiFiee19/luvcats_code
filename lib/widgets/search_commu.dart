import 'package:flutter/material.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/widgets/showsearch_commu.dart';

class CommuSearchDelegate extends SearchDelegate<Commu?> {
  final List<Commu> commulist;

  CommuSearchDelegate({required this.commulist});
  List<Commu>? commu;
  final ProfileServices profileServices = ProfileServices();

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
    final Map<String, List<Commu>> titleMap = {};

    commulist.forEach((commu) {
      final lowerCaseTitle = commu.title.toLowerCase();
      if (lowerCaseTitle.contains(query.toLowerCase())) {
        titleMap.putIfAbsent(lowerCaseTitle, () => []).add(commu);
      }
    });

    final titles = titleMap.keys.toList();

    final results = commulist.where((commu) {
      return commu.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        final title = titles[index];
        return ListTile(
          title: Text(title),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShowSearchCommu(query: title, commulist: results)),
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
