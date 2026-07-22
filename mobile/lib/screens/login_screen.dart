import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'main_menu_screen.dart';
import 'register_screen.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phone = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  bool hide = true;
  String error = '';
String appVersion = '';

  Future<void> login() async {

    setState(() {
      loading = true;
      error = '';
    });

    final ok = await AuthService.login(
      phone.text.trim(),
      password.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (ok) {

      Navigator.pushReplacement(
        context,
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
        
      );

    } else {

      setState(() {
        error = ApiService.lastError.isNotEmpty ? ApiService.lastError : 'خطای ورود یا اتصال به سرور';
      });

    }
  }


  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appVersion = '${info.version}+${info.buildNumber}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(
            colors:[
              Color(0xff6B3E26),
              Color(0xffD99A2B),
              Color(0xff0B1220),
            ],
          ),

        ),

        child: Center(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(24),

            child: Column(

              children:[

                const Icon(
                  Icons.bakery_dining,
                  size:90,
                  color:Color(0xffffd166),
                ),

                const SizedBox(height:20),

                const Text(
                  'Bakery Manager AI',
                  style:TextStyle(
                    color:Colors.white,
                    fontSize:28,
                    fontWeight:FontWeight.bold,
                  ),
                ),

                const SizedBox(height:30),


                Container(

                  padding:const EdgeInsets.all(24),

                  decoration:BoxDecoration(
                    color:Colors.white,
                    borderRadius:BorderRadius.circular(24),
                  ),


                  child:Column(

                    children:[

                      TextField(
                        controller:phone,
                        keyboardType:TextInputType.phone,
                        decoration:const InputDecoration(
                          labelText:'شماره موبایل',
                          prefixIcon:Icon(Icons.phone),
                        ),
                      ),


                      TextField(

                        controller:password,
                        obscureText:hide,

                        decoration:InputDecoration(

                          labelText:'رمز عبور',

                          prefixIcon:
                          const Icon(Icons.lock),

                          suffixIcon:IconButton(

                            icon:Icon(
                              hide
                              ? Icons.visibility_off
                              : Icons.visibility,
                            ),

                            onPressed:(){
                              setState(() {
                                hide=!hide;
                              });
                            },

                          ),

                        ),

                      ),


                      const SizedBox(height:15),


                      if(error.isNotEmpty)
                        Text(
                          error,
                          style:
                          const TextStyle(
                            color:Colors.red,
                          ),
                        ),


                      const SizedBox(height:20),


                      SizedBox(

                        width:double.infinity,

                        height:50,

                        child:ElevatedButton(

                          onPressed:
                          loading ? null : login,

                          child: loading

                          ? const CircularProgressIndicator()

                          : const Text(
                            'ورود به مدیریت نانوایی',
                          ),

                        ),

                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text('ثبت نام کاربر جدید'),
                      ),

                    ],

                  ),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }
}
