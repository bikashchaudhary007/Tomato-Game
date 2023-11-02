import 'package:flutter/material.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:tomatogame/Features/user_auth/presentation/widgets/form_container_widget.dart';

import 'home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),

              FormContainerWidget(
                hintText: "Email",
                isPasswordField: false,
              ),

              SizedBox(
                height: 10,
              ),

              FormContainerWidget(
                hintText: "Password",
                isPasswordField: true,
              ),

              SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Center(child: Text("Login", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                              (route) => false,
                        );
                      },

                      child: Text("Sing Up",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,),),
                    )
                  ],),




            ],
          ),
        ),
      ),
    );
  }
}
