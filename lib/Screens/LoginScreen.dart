import 'package:driver/Screens/Detailspage.dart';
import 'package:driver/Screens/GoogleMapScreen.dart';
import 'package:driver/commonFiles/AppColors.dart';
import 'package:driver/commonFiles/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading=false;
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ProgressWidget(
        isShow: _isLoading,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.1, 0.9],
              colors: [
                Color(0xFF4EC0E8).withOpacity(0.20),
                Color(0xFF7FD2EE).withOpacity(0.25),
                Color(0xFFFFFFFF).withOpacity(0.45)],

            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 35,right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                  Image.asset("assets/images/cfslogo.png",height: 42,width: 80,),
                  SizedBox(height: 80,),
                  Text("Welcome!",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500,),textScaleFactor: 1.0,),
                  Text("Sign in to continue",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: Color(0xFF6F93AC)),),
                  SizedBox(height: 50,),
                  Text("UserId",style: TextStyle(color: Color(0xFF707070)),),
                  SizedBox(height: 8,),
                  TextField(
                    controller: userIdController,
                    keyboardType:TextInputType.text,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightblue,width: 2),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFEEFED2E1)),
                            borderRadius: BorderRadius.circular(5)
                        ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.lightblue, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text("Password",style: TextStyle(color: Color(0xFF707070)),),
                  SizedBox(height: 8,),
                  TextField(
                    controller: passwordController,
                    keyboardType:TextInputType.text,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      fillColor: AppColors.lightblue,
                      suffixIcon:GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        child: Icon(
                          passwordVisible ? Icons.visibility_off : Icons.visibility,
                          //semanticLabel: _obscureText ? 'show password' : 'hide password',
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightblue,width: 2),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color:  AppColors.lightblue),
                            borderRadius: BorderRadius.circular(5)
                        ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.lightblue, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 50 ,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        height: 50,width: 110,
                        decoration: BoxDecoration(color: AppColors.lightblue,borderRadius: BorderRadius.all(Radius.circular(50))),
                        child: FlatButton(onPressed: (){
                          if(userIdController.text.isEmpty){
                            final snackBar = SnackBar(content: Text('Please enter your UserId'));
                            Scaffold.of(context).showSnackBar(SnackBar(content: snackBar));
                           // _scaffoldKey.currentState.showSnackBar(snackBar);
                            setState(() {
                              _isLoading=false;
                            });
                          }else if(passwordController.text.isEmpty){
                            final snackBar = SnackBar(content: Text('Please enter your Password'));
                            Scaffold.of(context).showSnackBar(SnackBar(content: snackBar));
                            setState(() {
                              _isLoading=false;
                            });
                          }else if(userIdController.text!="admin"){
                            final snackBar = SnackBar(content: Text('Please enter valid UserName'));
                            Scaffold.of(context).showSnackBar(SnackBar(content: snackBar));
                            setState(() {
                              _isLoading=false;
                            });
                          }else if(passwordController.text!="admin") {
                            final snackBar = SnackBar(content: Text('Please enter valid Password'));
                            Scaffold.of(context).showSnackBar(SnackBar(content: snackBar));
                            setState(() {
                              _isLoading=false;
                            });
                          }
                          else{
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                          }

                        }, child: Center(child: Text("LOGIN",style: TextStyle(color: Colors.white),)))),
                  )


                ],


              ),
            ),
          ),
        ),
      ),

    );
  }
}
