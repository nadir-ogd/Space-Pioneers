import 'package:astro01/variable_globale/variable.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:astro01/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/TextInput.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';
import 'package:email_auth/email_auth.dart';

// une page pour que l'utilisateur puisse inscrire dans l'application
bool cliqued = false;
const supabaseUrl = 'https://ltsahdljhuochhecajen.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMDQ3OTY4MiwiZXhwIjoxOTM2MDU1NjgyfQ.IoKgpB9APMw5Te9DYgbJZIbYcvPOwl41dl4-IKFjpVk';
final supabaseclient = SupabaseClient(supabaseUrl, supabaseKey);
//Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
bool _emailvalidate = false;

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  GlobalKey _formKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
            bottom: (MediaQuery.of(context).viewInsets.bottom - 100) > 0
                ? MediaQuery.of(context).viewInsets.bottom - 100
                : MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          gradient: myGradiant,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              'S\'inscrire',
              style: TextStyle(
                color: myRed,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.topCenter,
              children: [
                RegCard(
                  formKey: _formKey,
                ),
                Positioned(
                  top: -100,
                  child: Image(
                    height: 150,
                    width: 150,
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/other/astro.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RegCard extends StatefulWidget {
  RegCard({
    Key key,
    this.formKey,
  }) : super(key: key);
  GlobalKey<FormState> formKey;

  @override
  _RegCardState createState() => _RegCardState();
}

class _RegCardState extends State<RegCard> {
  DateTime _dateTime;
  String _dateValidate = "Date de Naissance";

  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _username;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
  }

  void sendOtp() async {
    EmailAuth.sessionName = "Company Name";
    bool result = await EmailAuth.sendOtp(receiverMail: _email.value.text);
    if (result) {
      setState(() {
        _emailvalidate = true;
      });
    } else {
      setState(() {
        _emailvalidate = false;
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // definir les deffirent champ de la page inscrire nom / email / mot de passe / datte de naissance
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextForm(
                    // champ username
                    labelText: "Username",
                    controller: _username,
                    validator: (value) {
                      //valieder le nom de l'utilisateur s'il est correcte ou non
                      if (value == null || value.isEmpty) {
                        return ' please enter your name ';
                      }

                      return null;
                    }),
                SizedBox(
                  height: 12,
                ),

                CustomTextForm(
                    // valider l'email ed l'utilisateur s'il est bien formé
                    labelText: "Email",
                    controller: _email,
                    validator: (value) {
                      setState(() {
                        _email.text = _email.text.trim();
                      });
                      if (value == null || value.isEmpty) {
                        return ' please enter your email ';
                      } else {
                        return null;
                      }
                    }),
                SizedBox(
                  height: 12,
                ),
                CustomTextForm(
                    // champ pour le mot de passe de l'utilisateur
                    obscured: true,
                    labelText: "Mot de Passe",
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' please enter your mot de passe ';
                      }

                      return null;
                    }),

                SizedBox(
                  height: 12,
                ),
                //date de naissance
                FormField(
                  /// champ pour selectioner la date de naissance de l'utilisateur
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (e) {
                    _dateValidate = _dateTime == null
                        ? 'Il faut selectionner une date'
                        : "";
                  },
                  builder: (FormFieldState<dynamic> e) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: myRed,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showDatePicker(
                            initialEntryMode: DatePickerEntryMode.input,
                            context: context,
                            initialDate:
                                _dateTime == null ? DateTime.now() : _dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            setState(() {
                              _dateTime = value;
                            });
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: _dateValidate !=
                                      "Il faut selectionner une date"
                                  ? myBlue
                                  : myYellow,
                              size: 30,
                            ),
                            Text(
                              _dateTime == null
                                  ? _dateValidate
                                  : _dateTime.toString().split(" ")[0],
                              style: TextStyle(
                                color: _dateValidate ==
                                        "Il faut selectionner une date"
                                    ? Colors.red
                                    : null,
                                fontSize: 17,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          child: Text(
                            'S\'inscrire',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            backgroundColor: myRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                color: myRed,
                                width: 2,
                              ),
                            ),
                          ),
                          onPressed: () {
                            // verefier si deja cliquer dans le boutton il ne fonctionne pas sinon il fonctionne bien pour s'inscrire
                            cliqued ? null : _signup();
                          }),
                    ),
                  ],
                ),

                ///tested
              ],
            ),
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Future _signup() async {
    /// une fonction pour inscrire avec un nouveau compte
    cliqued = true;

    if (_formKey.currentState.validate() && _username.text.length <= 14) {
      final signInResult = await Injector.appInstance
          .get<SupabaseClient>()
          .auth
          .signUp(_email.text.split(" ")[0], _password.text);

      if (signInResult != null && signInResult.user != null) {
        user.email = _email.text.split(" ")[0];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', user.email);

        await supabaseclient.from("Trace").insert({
          "email": _email.text.split(" ")[0],
          'earth': 0,
          'jupiter': 0,
          'mars': 0,
          'mercury': 0,
          'neptune': 0,
          'saturn': 0,
          'uranus': 0,
          'venus': 0,
          'soleil': 0
        }).execute();
        await supabaseclient.from("user").insert({
          "name": _username.text,
          "email": _email.text.split(" ")[0],
          'etoiles': 0,
          'naissance': _dateTime.toString().split(" ")[0],
          'avatar': 'default',
          'badges': '000000000001',
        }).execute();
        Navigator.pushReplacementNamed(context, '/homeScreen');
      } else if (signInResult.error.message != null) {
        // pour afficher les message d'erreures
        String message;

        message = signInResult.error.message;

        TextButton(
            onPressed: () {}, child: Text(' erreur dans le mot de passe'));

        showFlash(
            context: context,
            duration: const Duration(seconds: 2),
            builder: (context, controller) {
              return Flash.dialog(
                  controller: controller,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  backgroundGradient: LinearGradient(colors: [myRed, myRed]),
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        backgroundColor: myRed,
                      ),
                    ),
                  ));
            });
      }
    } else if (_username.text.length > 14) {
      String message = ' taille maximale du nom est 14';
      showFlash(
          context: context,
          duration: const Duration(seconds: 2),
          builder: (context, controller) {
            return Flash.dialog(
                controller: controller,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                backgroundGradient: LinearGradient(colors: [myRed, myRed]),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      backgroundColor: myRed,
                    ),
                  ),
                ));
          });
    }
    cliqued = false;
  }
}
