import 'package:e_commerce_app/screens/product_display_screen/cubit/product_display_cubit.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDisplayScreen extends StatefulWidget {
  const ProductDisplayScreen(
      {required this.id,
      super.key});

  final int id;

  @override
  State<ProductDisplayScreen> createState() => _ProductDisplayScreenState();
}

class _ProductDisplayScreenState extends State<ProductDisplayScreen> {
  ValueNotifier<int> quantity = ValueNotifier<int>(1);
  ValueNotifier<double> totalPrice = ValueNotifier<double>(0);

  @override
  void initState() {
    context.read<ProductDisplayCubit>().getData(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDisplayCubit, ProductDisplayState>(
      listener: (context, state) {
        if(state.asuccess){
          showAlertMessage(context: context, message: state.message,voidCallback: (){
          Navigator.of(context).pop();
          });
        }
        // else{
        //   showAlertMessage(context: context, message: state.message);
        // }
      },
      child: BlocBuilder<ProductDisplayCubit, ProductDisplayState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 232, 232, 232),
            appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white)),
                backgroundColor: themeColor,
                centerTitle: true,
                title: Text(state.model?.data?.category ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600))),
            body: state.loading ? const Center(child: CircularProgressIndicator(color: themeColor),) : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.network(state.model?.data?.image ?? "", fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: Text(state.model?.data?.title ?? "",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                      const SizedBox(width: 70),
                      Container(
                        padding: const EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        child: Text(r"$" "${state.model?.data?.nprice ?? ""}",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 18, 73, 117),
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 0),
                    alignment: Alignment.centerLeft,
                    child: const Text("About",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                        height: 2, width: double.infinity, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(state.model?.data?.description ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: const Text("Ratings : ",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              getStarRating((state.model?.data?.rating?.rate ?? 0).toDouble()),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 214, 193, 9),
                                  fontSize: 28))),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text("Reviews : ",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(state.model?.data?.rating?.count.toString() ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 4, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text("views",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black45)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      totalPrice.value =
                          (quantity.value * (state.model?.data?.nprice ?? 0)).toDouble();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => bottomSheet(state));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text("Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomSheet(ProductDisplayState state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      color: const Color.fromARGB(255, 241, 244, 243),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.network(state.model?.data?.image ?? "", fit: BoxFit.fill),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(state.model?.data?.title ?? "",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis)),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.only(right: 15),
                alignment: Alignment.centerRight,
                child: Text(r"$" "${state.model?.data?.nprice ?? ""}",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 18, 73, 117),
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Quantity : ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 55),
              quantityMinusButton(state),
              const SizedBox(width: 25),
              ValueListenableBuilder<int>(
                valueListenable: quantity,
                builder: (context, value, child) {
                  return Text('$value', style: const TextStyle(fontSize: 18));
                },
              ),
              const SizedBox(width: 25),
              quantityAddButton(state),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Total Price : ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 25),
              ValueListenableBuilder<double>(
                valueListenable: totalPrice,
                builder: (context, value, child) {
                  return Text(value.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 18));
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              context.read<ProductDisplayCubit>().addToCart(state.model?.data?.id ?? 0, state.model?.data?.image ?? "",
                  state.model?.data?.category ?? "",quantity.value, state.model?.data?.nprice.toString() ?? "",totalPrice.value.toString(), state.model?.data?.title ?? "");
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text("Add to cart",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quantityMinusButton(ProductDisplayState state) {
    return GestureDetector(
      onTap: () {
        quantity.value--;
        if (quantity.value < 1) {
          quantity.value = 1;
        }
        totalPrice.value = (quantity.value * (state.model?.data?.nprice ?? 0)).toDouble();
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

  Widget quantityAddButton(ProductDisplayState state) {
    return GestureDetector(
      onTap: () {
        quantity.value++;
        totalPrice.value = (quantity.value * (state.model?.data?.nprice ?? 0)).toDouble();
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
