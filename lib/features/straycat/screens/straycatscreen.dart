import 'package:flutter/material.dart';
import 'package:luvcats_app/features/auth/services/auth_service.dart';
import 'package:luvcats_app/features/detail_straycat/screens/detail_straycat.dart';
import 'package:luvcats_app/features/straycat/screens/poststraycat.dart';
import 'package:luvcats_app/features/straycat/services/cat_service.dart';
import 'package:luvcats_app/models/poststraycat.dart';
import 'package:luvcats_app/widgets/loader.dart';
import 'package:luvcats_app/widgets/single_cat.dart';

class StrayCatScreen extends StatefulWidget {
  const StrayCatScreen({Key? key}) : super(key: key);

  @override
  State<StrayCatScreen> createState() => _StrayCatScreenState();
}

class _StrayCatScreenState extends State<StrayCatScreen> {
  // List<User>? users;
  List<Cat>? cats;
  final CatServices catServices = CatServices();
  final AuthService authService = AuthService();
  // late User users;

  @override
  void initState() {
    super.initState();
    fetchAllCats();
  }

  fetchAllCats() async {
    cats = await catServices.fetchAllCats(context);
    if (mounted) {
      setState(() {});
    }
    // setState(() {});
  }

  Future<void> _getData() async {
    setState(() {
      fetchAllCats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return cats == null
        ? const Loader()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            body: RefreshIndicator(
              onRefresh: _getData,
              child: GridView.builder(
                itemCount: cats!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  mainAxisExtent: 310,
                ),
                itemBuilder: (context, index) {
                  final catData = cats![index];

                  return InkWell(
                    onTap: () {
                      // ทำสิ่งที่คุณต้องการเมื่อกดที่ Container
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailStraycatScreen(cat: catData),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            child: SingleCat(
                              image: catData.images[0],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${catData.user_id}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .merge(
                                        const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  "${catData.gender}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostStrayCat(),
                    ),
                  );
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
          );
  }
}
