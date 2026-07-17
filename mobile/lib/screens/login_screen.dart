import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../routes/app_router.dart';

class LoginScreen extends StatefulWidget{
const LoginScreen({super.key});

@override
State<LoginScreen> createState()=>_LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

final phone=TextEditingController();
final password=TextEditingController();

void login() async{

final result=await AuthService.login(
phone.text,
password.text
);

await UserService.saveLogin(result);

final role=result['user']['role'];

if(!mounted)return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder:(_)=>AppRouter.home(role)
)
);

}

@override
Widget build(BuildContext context){

return Scaffold(

appBar:AppBar(
title:const Text('ورود نانوایی'),
),

body:Padding(
padding:const EdgeInsets.all(20),

child:Column(

children:[

TextField(
controller:phone,
decoration:
const InputDecoration(
labelText:'شماره موبایل'
),
),

TextField(
controller:password,
obscureText:true,
decoration:
const InputDecoration(
labelText:'رمز عبور'
),
),

ElevatedButton(
onPressed:login,
child:
const Text('ورود'),
)

],

),

),

);

}

}
