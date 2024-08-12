import 'package:get/get.dart';
import 'package:cehpoint_marketplace/authentication/Views/loginView/login_view.dart';
import 'package:cehpoint_marketplace/authentication/Views/registerView/register_view.dart';
import 'package:cehpoint_marketplace/authentication/onBoardingScreen/onboarding_screen.dart';
import 'package:cehpoint_marketplace/authentication/auth_home.dart';
import 'package:cehpoint_marketplace/home/home_screen.dart';
import 'package:cehpoint_marketplace/home/properties/screens/properties_detail_screen.dart';
import 'package:cehpoint_marketplace/home/properties/screens/propery_see_all_screen.dart';
import 'package:cehpoint_marketplace/navigation/bottomNavigationItems/profilePage/profile_page.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';

class AppPages {
  static List<GetPage> appPages = [
    GetPage(name: AppRoutes.authHome, page: () => const AuthHome()),
    GetPage(name: AppRoutes.homeScreen, page: () => const HomeScreen()),
    GetPage(
        name: AppRoutes.onBoardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.loginScreen, page: () => const LoginView()),
    GetPage(name: AppRoutes.registerScreen, page: () => const RegisterView()),
    GetPage(
        name: AppRoutes.propertiesDetailScreen,
        page: () => const PropertiesDetailScreen()),
    GetPage(
      name: AppRoutes.propertiesSeeAllScreen,
      page: () => const PropertySeeAllScreen(),
    ),
    GetPage(name: AppRoutes.profilePageScreen, page: () => const ProfilePage()),
  ];
}
