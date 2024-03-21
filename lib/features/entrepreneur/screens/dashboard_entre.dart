import 'package:flutter/material.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/features/dashborad/screens/dashboard_entre.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Report_Entre extends StatefulWidget {
  const Report_Entre({
    Key? key,
  }) : super(key: key);

  @override
  State<Report_Entre> createState() => _Report_EntreState();
}

class _Report_EntreState extends State<Report_Entre> {
  final CathotelServices cathotelServices = CathotelServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          DashboardEntre(
            reviews: cathotelServices.fetchReviewsUser(
                context, userProvider.user.id),
          ),
        ],
      ),
    );
  }
}