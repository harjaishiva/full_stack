import 'package:flutter/material.dart';

class PopUpView extends StatefulWidget {
  final String popUpTitle;
  final VoidCallback voidCallback;
  const PopUpView({Key? key, this.popUpTitle = "", required this.voidCallback})
      : super(key: key);

  @override
  PopUpViewState createState() => PopUpViewState();
}

class PopUpViewState extends State<PopUpView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(.7),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Center(
                child: Container(
                  height: 250,
                  width: 340,
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/images/Popup.png"),
                      Positioned(
                          top: 85,
                          left: 0,
                          child: Container(
                              width: 340,
                              color: Colors.transparent,
                              child: Center(
                                  child: Text(widget.popUpTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600))))),
                      Positioned(
                          bottom: 45,
                          left: (340 / 2) - 60,
                          child: GestureDetector(
                            onTap: widget.voidCallback,
                            child: Container(
                                width: 120,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23),
                                  color: Colors.green,
                                ),
                                child: const Center(
                                    child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ))),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertMessage(
        {required BuildContext context,
        required String message,
        VoidCallback? voidCallback}) =>
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => PopUpView(
              popUpTitle: message,
              voidCallback: () {
                Navigator.pop(context);
                if (voidCallback != null) {
                  voidCallback();
                }
              },
            )));


class PopUpTwoView extends StatefulWidget {
  final String popUpTitle;
  final VoidCallback onTapYes;
  final VoidCallback onTapNo;
  final String yes;
  final String no;
  const PopUpTwoView({Key? key,this.yes = "Yes", this.no = "No", this.popUpTitle = "",required this.onTapYes, required this.onTapNo})
      : super(key: key);

  @override
PopUpTwoViewState createState() => PopUpTwoViewState();
}

class PopUpTwoViewState extends State<PopUpTwoView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(.7),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Center(
                child: Container(
                  height: 250,
                  width: 340,
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/images/Popup.png"),
                      Positioned(
                          top: 85,
                          left: 0,
                          child: Container(
                              width: 340,
                              color: Colors.transparent,
                              child: Center(
                                  child: Text(widget.popUpTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600))))),
                      Positioned(
                          bottom: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: widget.onTapYes,
                                child: Container(
                                    width: 120,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(23),
                                      color: Colors.green,
                                    ),
                                    child: Center(
                                        child: Text(
                                      widget.yes,
                                      style: const  TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ))),
                              ),
                          const SizedBox(width:20),
                                  GestureDetector(
                                    onTap: widget.onTapNo,
                                    child: Container(
                                    width: 120,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(23),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      widget.no,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ))),
                                  ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertTwoMessage(
        {required BuildContext context,
        required String message,
        VoidCallback? onTapYes,
        VoidCallback? onTapNo,
        String? yes,
        String? no}) =>
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => PopUpTwoView(
              popUpTitle: message,
              yes: yes ?? "Yes",
              no: no ?? "No",
              onTapYes: () {
                Navigator.pop(context);
                if (onTapYes != null) {
                  onTapYes();
                }
              },
              onTapNo: () {
                Navigator.pop(context);
                if (onTapNo != null) {
                  onTapNo();
                }
              },
            )));
