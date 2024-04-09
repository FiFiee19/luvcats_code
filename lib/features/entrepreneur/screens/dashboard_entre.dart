import 'package:flutter/material.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/features/dashborad/screens/dashboard_entre.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ReportEntre extends StatefulWidget {
  const ReportEntre({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportEntre> createState() => _ReportEntreState();
}

class _ReportEntreState extends State<ReportEntre> {
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
