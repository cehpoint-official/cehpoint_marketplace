import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/firebase_options.dart';
import 'package:cehpoint_marketplace/models/user_model.dart';
import 'package:cehpoint_marketplace/routes/app_pages.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Retrieve user data from local storage
  await UserDataService().retrieveUserDataLocally();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  GlobalUtil.isViewed = prefs.getInt(GlobalUtil.onBordingToken);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MainApp(navigatorKey: navigatorKey));
  });
}

class MainApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MainApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // supportedLocales: AppLocalizations.supportedLocales,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: ColorConstants.blue700,
          appBarTheme: const AppBarTheme(
              // iconTheme: IconThemeData(color: Colors.white),
              )
          // primarySwatch: Colors.blue,
          ),
      initialRoute: GlobalUtil.isViewed == 0 || GlobalUtil.isViewed == null
          ? AppRoutes.onBoardingScreen
          : AppRoutes.authHome,
      getPages: AppPages.appPages,
    );
  }
}
