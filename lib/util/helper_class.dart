import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin HelperClass {
  getScreenWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  getScreenHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  // onn resume
  // SystemChannels.lifecycle.setMessageHandler((msg) async {
  //   debugPrint('SystemChannels> $msg');
  //   if(msg == AppLifecycleState.resumed.toString()){
  //
  // }
  //   });

  Size getScreenSize(context) {
    return MediaQuery.of(context).size;
  }

  toast(String message) {
    // print(message);
    Fluttertoast.showToast(msg: message);
  }

  String notInternetMsg(String msg) {
    print("sdsadsadas    " + msg);
    if (msg.contains('SocketException: Failed host lookup: ')) {
      return 'No Internet Connection';
    } else if (msg.contains('OS Error: Connection refused')) {
      return 'Network Error';
    } else if (msg.contains('OS Error: Connection reset by peer')) {
      return 'Server Timeout';
    } else if (msg.contains('OS Error:')) {
      return 'Something went wrong, Please retry.';
    } else {
      return msg.replaceAll("Exception:", "");
    }
  }

  // Future<void> onLoading(context, LoaderVisibility loader) {
  //   loader.changeLoaderVisibility();
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Platform.isIOS
  //           ? CupertinoActivityIndicator(
  //               color: AppColors().blue,
  //               radius: 20,
  //             )
  //           : Center(
  //               child: CircularProgressIndicator(
  //                 color: AppColors().blue,
  //               ),
  //             );
  //     },
  //   ).then((value) {
  //     loader.changeLoaderVisibility();
  //     print("chakta oya");
  //   });
  // }

  Future<dynamic> pushToScreenAndClearStack(context, Widget call) {
    FocusScope.of(context).unfocus();
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) {
      return call;
    }), (Route<dynamic> route) => false);
  }

  Future<dynamic> pushToNextScreen(context, Widget call, bool replace) {
    if (replace) {
      FocusScope.of(context).unfocus();
      return Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 150),
          // Forward Duration
          reverseTransitionDuration: Duration(milliseconds: 150),
          // Reverse Duration
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return call;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return CupertinoPageTransition(
              linearTransition: true,
              primaryRouteAnimation: animation,
              secondaryRouteAnimation: secondaryAnimation,
              // opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      return Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 150),
          // Forward Duration
          reverseTransitionDuration: Duration(milliseconds: 150),
          // Reverse Duration
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return call;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return CupertinoPageTransition(
              linearTransition: true,
              primaryRouteAnimation: animation,
              secondaryRouteAnimation: secondaryAnimation,
              // opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  popToBackScreen(context) {
    Navigator.of(context).pop();
  }
}
