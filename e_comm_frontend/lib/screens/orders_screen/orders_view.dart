import 'package:e_commerce_app/screens/orders_screen/cubit/orders_cubit.dart';
import 'package:e_commerce_app/screens/product_display_screen/cubit/product_display_cubit.dart';
import 'package:e_commerce_app/screens/product_display_screen/product_display_view.dart';
import 'package:e_commerce_app/utils/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> placedOrdersList = [];

  List<ValueNotifier<int>> quantity = [];
  List<ValueNotifier<double>> totalPrice = [];
  int screenIndex = 1;

  List<bool> showCancelButton = [];
  bool remove = false;

  @override
  void initState() {
    context.read<OrdersCubit>().callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state.success == true) {
          context.read<OrdersCubit>().update();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            centerTitle: true,
            title: const Text("Cart",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600)),
            backgroundColor: themeColor,
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              inCart(),
            ],
          ),
          bottomNavigationBar:
              bottomNavigationBar(index: screenIndex, context: context)),
    );
  }

  Widget inCart() {
    return (BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        return (state.model?.data?.isEmpty == true ||
                state.model?.data?.length == null)
            ? Padding(
                padding: EdgeInsets.only(
                    top: ((MediaQuery.of(context).size.height * 0.5) - 150),
                    left: (MediaQuery.of(context).size.width * 0.3)),
                child: const Text("Cart is empty",
                    style: TextStyle(
                        color: buttonColor,
                        fontSize: 26,
                        fontWeight: FontWeight.w600)),
              )
            : orderInCartList();
      },
    ));
  }

  Widget orderInCartList() {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      for (int i = 0; i < (state.model?.data?.length ?? 0); i++) {
        quantity.add(ValueNotifier<int>(0));
        totalPrice.add(ValueNotifier<double>(0));
      }

      for (int i = 0; i < (state.model?.data?.length ?? 0); i++) {
        quantity[i] = ValueNotifier<int>((state.model?.data?[i].quantity ?? 0));
        totalPrice[i] = ValueNotifier<double>(
            (state.model?.data?[i].tprice ?? 0).toDouble());
      }
      return SizedBox(
          height: MediaQuery.of(context).size.height - 220,
          width: MediaQuery.of(context).size.height - 30,
          child: ListView.builder(
            itemCount: state.model?.data?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left:8,right:8),
                child: itemList(index: index),
              );
            },
          ));
    });
  }


Widget itemList({required int index}) {
  return BlocBuilder<OrdersCubit, OrdersState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = kIsWeb && constraints.maxWidth > 600;

            return Center(
              child: Container(
                width: isWeb ? 600 : double.infinity, // ✅ fixed width on web
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themeColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    /// ---------------- IMAGE + TITLE + PRICE ----------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.network(
                              state.model?.data?[index].image ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.model?.data?[index].title ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: isWeb ? 2 : 1, // ✅ wrap on web
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          alignment: Alignment.centerRight,
                          child: Text(
                            "\$${state.model?.data?[index].price ?? ""}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 18, 73, 117),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// ---------------- CATEGORY ----------------
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Category : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Flexible(
                          child: Text(
                            state.model?.data?[index].category ?? "",
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 13),
                    divider(),
                    const SizedBox(height: 13),

                    /// ---------------- QUANTITY ----------------
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Quantity : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 55),
                        quantityMinusButton(
                          price: (state.model?.data?[index].price ?? 0).toDouble(),
                          i: index,
                        ),
                        const SizedBox(width: 25),
                        ValueListenableBuilder<int>(
                          valueListenable: quantity[index],
                          builder: (context, value, child) {
                            return Text(
                              '$value',
                              style: const TextStyle(fontSize: 18),
                            );
                          },
                        ),
                        const SizedBox(width: 25),
                        quantityAddButton(
                          price: (state.model?.data?[index].price ?? 0).toDouble(),
                          i: index,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// ---------------- TOTAL PRICE ----------------
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Total Price : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 25),
                        ValueListenableBuilder<double>(
                          valueListenable: totalPrice[index],
                          builder: (context, value, child) {
                            return Text(
                              value.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 18),
                            );
                          },
                        ),
                      ],
                    ),

                    divider(),
                    const SizedBox(height: 25),

                    /// ---------------- BUTTONS ----------------
                    Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => ProductDisplayCubit(),
                child: ProductDisplayScreen(
                  id: state.model?.data?[index].itemId ?? 0,
                ),
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          height: 50,
          constraints: const BoxConstraints(maxWidth: 250), // ✅ limit on web
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Product",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
    Expanded(
      child: GestureDetector(
        onTap: () {
          showAlertTwoMessage(
            context: context,
            message:
                "Are you sure, you want to remove this from order list?",
            onTapYes: () {
              context
                  .read<OrdersCubit>()
                  .deleteFromCart(state.model?.data?[index].id ?? 0);
            },
            onTapNo: () {},
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          height: 50,
          constraints: const BoxConstraints(maxWidth: 250), // ✅ limit on web
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 194, 194, 194),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Remove",
            style: TextStyle(
              color: buttonColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  ],
),

                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}


  Widget quantityMinusButton({required double price, required int i}) {
    return GestureDetector(
      onTap: () {
        quantity[i].value--;
        if (quantity[i].value < 1) {
          quantity[i].value = 1;
        }
        totalPrice[i].value = (quantity[i].value * price);
      },
      child: Container(
          alignment: Alignment.center,
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(10)),
          child: const Icon(
            Icons.remove,
            color: Colors.white,
            size: 16,
          )),
    );
  }

  Widget quantityAddButton({required double price, required int i}) {
    return GestureDetector(
      onTap: () {
        quantity[i].value++;
        totalPrice[i].value = (quantity[i].value * price);
      },
      child: Container(
          alignment: Alignment.center,
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(10)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          )),
    );
  }
}
