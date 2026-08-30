import 'package:get/get.dart';
import 'package:gufgaf/app/routes/app_routes.dart';
import 'package:gufgaf/app/views/login_view.dart';
import 'package:gufgaf/app/views/register_view.dart';

class AppPages {
  static var routes = [
    GetPage(name: AppRoutes.login, page: ()=> LoginView()),
    GetPage(name: AppRoutes.register, page: ()=> RegisterView()),
  ];
}