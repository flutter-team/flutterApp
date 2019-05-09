import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';
import '../models/auth.dart';


class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
    'acceptTerms': false
  };
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController=TextEditingController();
  AuthMode _authMode=AuthMode.Login;
  AnimationController _controller;
  Animation<Offset> _slideTrasition;
 void initState(){
   _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 200));
   _slideTrasition= Tween<Offset>(begin: Offset(0.0, -2.0),end: Offset.zero).animate(CurvedAnimation( parent: _controller,curve:Curves.fastOutSlowIn));
super.initState();
  }
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage(
        'pictures/key.jpg',
      ),
      fit: BoxFit.fill,
     
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-mail',
          icon: Icon(Icons.person),
          filled: true,
          fillColor: Colors.blueGrey[200]),
      onSaved: (String value) {
        _formData['email'] = value;
      },
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(r'^\w+([-_.]*)@\w{5,6}\.\w{3,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          icon: Icon(Icons.lock),
          filled: true,
          fillColor: Colors.blueGrey[200]),controller: _passwordController,
      onSaved: (String value) {
        _formData['password'] = value;
      },
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'Please enter valid password';
        }
      },
    );
  }
   Widget _buildConfirmPasswordTextField() {

    return FadeTransition(opacity: CurvedAnimation(parent: _controller,curve: Curves.easeIn), child: SlideTransition(position: _slideTrasition, child:  TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          icon: Icon(Icons.lock),
          filled: true,
          fillColor: Colors.blueGrey[200]),
          obscureText: true,
     
      validator: (String value ) {
        if (_passwordController.text!=value && _authMode==AuthMode.Signup) {
          return 'password dont match';
        }
      },
    ),),
    );
  }

  Widget _buildAcceptTerms() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function authenticate) async {
    
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
     Map<String, dynamic> successInformation;
   
     successInformation =
          await  authenticate(_formData['email'], _formData['password'],_authMode);
    
    
      if (successInformation['success']) {
        //Navigator.pushReplacementNamed(context, '/');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('An Error Occurred!'),
                content: Text(successInformation['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * .8;
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              image: _buildBackgroundImage(),
            ),
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    width: targetWidth,
                    child: Column(children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                       SizedBox(
                        height: 10.0,
                      ),
                   _buildConfirmPasswordTextField(),
                      _buildAcceptTerms(),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(child: Text('switch to ${_authMode==AuthMode.Login? 'signup' : 'login'}'), 
                     onPressed: (){setState(() {
                       if (_authMode==AuthMode.Login){
                         setState(() {
                           _authMode=AuthMode.Signup;
                         });
                         _controller.forward();
                       }else{
                         setState(() {
                                    _authMode=AuthMode.Login;

                         });
                         _controller.reverse();
                       }
                     });
                      
                     },
                         ),
                      SizedBox(
                        height: 10.0,
                      ),
                     
                    ScopedModelDescendant<MainModel>(builder: (BuildContext context ,Widget child,MainModel model)
                    {return model.isLoading?CircularProgressIndicator():
                    RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text(_authMode==AuthMode.Login?
                          'Login':'Signup'
                        ),
                        onPressed:()=> _submitForm(model.authenticate),
                      );},)  ,
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
