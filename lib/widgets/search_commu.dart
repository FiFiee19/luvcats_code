import 'package:flutter/material.dart';
import 'package:luvcats_app/config/datetime.dart';
import 'package:luvcats_app/features/community/screens/detail_comment.dart';
import 'package:luvcats_app/features/community/services/commu_service.dart';
import 'package:luvcats_app/features/profile/services/profile_service.dart';
import 'package:luvcats_app/models/postcommu.dart';
import 'package:luvcats_app/providers/commu_provider.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/carouselslider.dart';
import 'package:luvcats_app/widgets/like_animation.dart';
import 'package:luvcats_app/widgets/show_search.dart';
import 'package:provider/provider.dart';

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
    

    void delete(String commu) {
      profileServices.deleteCatCommu(context, commu);
    }

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
                    ShowSearcher(query: title, commulist: results)),
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
