import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';

class StartScreen extends StatefulWidget{
const StartScreen({super.key});

@override
State<StartScreen> createState()=>_StartScreenState();
}


class _StartScreenState extends State<StartScreen>{

@override
void initState(){
super.initState();
check();
}


void check() async{

final token=await StorageService.getToken();

if(token!=null){

// بعداً اینجا اطلاعات کاربر را از API می‌گیریم

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder:(context)=>const LoginScreen()
)
);

}else{

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder:(context)=>const LoginScreen()
)
);

}

}


@override
Widget build(BuildContext context){

return const Scaffold(
body:Center(
child:CircularProgressIndicator()
),
);

}

}
