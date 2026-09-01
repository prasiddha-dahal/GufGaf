import 'package:get/get.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/views/home_view.dart';
import 'package:gufgaf/app/views/login_view.dart';
import 'package:gufgaf/app/views/profile_view.dart';
import 'package:gufgaf/app/views/register_view.dart';
import 'package:gufgaf/app/views/search_user_view.dart';

class AppPages {
  static var routes = [
    GetPage(name: AppRoutes.login, page: ()=> LoginView()),
    GetPage(name: AppRoutes.register, page: ()=> RegisterView()),
    GetPage(name: AppRoutes.home, page: ()=> HomeView(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.profile, page: ()=> ProfileView(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.searchUsers, page: ()=> SearchUserView(), transition: Transition.fadeIn),
  ];
}