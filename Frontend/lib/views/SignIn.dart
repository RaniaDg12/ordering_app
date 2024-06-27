import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/SignIn.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInModel = Provider.of<SignInModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 100,
              child: Image.asset('assets/logo.png'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenue !',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40), // Adjusted height to 40
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nom utilisateur',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => signInModel.setUsername(value),
                ),
                SizedBox(height: 10), // Reduced height to 10
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) => signInModel.setPassword(value),
                ),
                SizedBox(height: 10), // Reduced height to 10
                if (signInModel.errorMessage != null)
                  Text(
                    signInModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 10), // Reduced height to 10
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: signInModel.isLoading
                      ? null
                      : () async {
                    await signInModel.signIn();
                    if (signInModel.errorMessage == null) {
                      Navigator.pushNamed(context, '/');
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                    child: signInModel.isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                      'Se connecter',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
