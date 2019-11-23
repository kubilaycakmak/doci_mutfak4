import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/last_orders.dart';

final String loginCheckUrl = 'http://68.183.222.16:8080/api/userAccount/login';
final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
final String securityQuestions = 'http://68.183.222.16:8080/api/securityQuestion/all';
final String registerCheck = 'http://68.183.222.16:8080/api/userAccount/create';
final String changePass = 'http://68.183.222.16:8080/api/userAccount/changePassword ';
final String sendOrder = 'http://68.183.222.16:8080/api/order/create';
final String userCheckUrl = 'http://68.183.222.16:8080/api/userAccount/check?username=$username';
final String isOpen = 'http://68.183.222.16:8080/api/time/isopen';
final String changePassrequest = 'http://68.183.222.16:8080/api/userAccount/changePassword/?currentPassword=';
final String updateUrl = 'http://68.183.222.16:8080/api/user/update';
final String menuUrl = 'http://68.183.222.16:8080/api/dociproduct/all';
final String orderUrl = 'http://68.183.222.16:8080/api/order/user';
final String ratingUrl = 'http://68.183.222.16:8080/api/order/rate?orderId=$selectedId';
final String orderCreate = 'http://68.183.222.16:8080/api/order/create';
final String paymentMethodsUrl ='http://68.183.222.16:8080/api/paymentmethod/all';