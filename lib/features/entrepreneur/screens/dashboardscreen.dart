import 'package:flutter/material.dart';
import 'package:luvcats_app/features/cathotel/services/cathotel_service.dart';
import 'package:luvcats_app/features/dashboard/screens/dashboard_entre.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
