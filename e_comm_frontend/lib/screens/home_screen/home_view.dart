import 'package:e_commerce_app/screens/home_screen/cubit/home_screen_cubit.dart';
import 'package:e_commerce_app/screens/product_display_screen/cubit/product_display_cubit.dart';
import 'package:e_commerce_app/screens/product_display_screen/product_display_view.dart';
import 'package:e_commerce_app/utils/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int screenIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeScreenCubit>().getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
      return PopScope(
        canPop: true,
        child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            centerTitle: true,
            title: const Text("Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600)),
            backgroundColor: themeColor,
          ),
          body: (state.loading)
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 300,
                            crossAxisSpacing: 0),
                    itemCount: state.getData?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return listTile(state, index,context);
                    },
                  ),
                ),
          bottomNavigationBar:
              bottomNavigationBar(index: screenIndex, context: context),
        ),
      );
    });
  }

  Widget listTile(HomeScreenState state, int index, BuildContext cont) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              (context),
              MaterialPageRoute(
                  builder: (context) => BlocProvider(create: (context) => ProductDisplayCubit(),child:ProductDisplayScreen(
                      id: int.parse(state.getData?.data?[index].id.toString() ?? "0")))));
        },
        child: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 198, 248, 242),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Image.network(state.getData?.data?[index].image ?? "",
                    fit: BoxFit.fill),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          state.getData?.data?[index].title ?? "N/A",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        )),
                    Row(children: [
                      Text(
                          "\$${(state.getData?.data?[index].nprice ?? 0).toString()}  ",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),
                      Text(
                        "\$${(state.getData?.data?[index].mprice ?? 0).toString()}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 3,
                            decorationColor: Colors.grey),
                      )
                    ]),
                    Row(children: [
                      Text(
                          getStarRating(double.parse(
                              (state.getData?.data?[index].rating?.rate ?? 0)
                                  .toString())),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 212, 191, 6))),
                      const SizedBox(width: 5),
                      Text(
                          (state.getData?.data?[index].rating?.rate ?? 0)
                              .toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 212, 191, 6),
                              fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    String stars = '★' * fullStars;
    if (hasHalfStar) {
      stars += '✬';
    }
    stars += '☆' * emptyStars;

    return stars;
  }
}
