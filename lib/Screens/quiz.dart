import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:astro01/Screens/bravoNiveau.dart';
import 'package:astro01/Screens/loading.dart';
import 'package:astro01/Screens/planetChoice.dart';
import 'package:astro01/classes/questions.dart';
import 'package:astro01/components/InfoSup.dart';
import 'package:astro01/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:astro01/components/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astro01/variable_globale/variable.dart';
import 'package:provider/provider.dart';
import '../components/InfoSup.dart';

bool vfquestion;
bool verefication = false;
int verefier = -1;
String planeteNAME;
List<String> propo = ['a', 'b', 'c', 'd'];
int points = 0;
bool cliquer = false;
List<int> ind = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; //tableau d'indices des 10 questions (pour les afficher aléatoirement)
List<int> indices = [0, 1, 2, 3]; //tableau d'indices des 4 propositions de chaque question (pour les afficher aléatoirement)
AssetsAudioPlayer wrongAnswerPlayer = AssetsAudioPlayer(); //son de mauvaise réponse 
AssetsAudioPlayer rightAnswerPlayer = AssetsAudioPlayer(); //son de réponse correcte

class Ind extends ChangeNotifier {
  List<int> ind = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  int nb = nbTentatives;

  void updateInd(List<int> newindice, int num) {
    ind = newindice;
    nb = num;
    notifyListeners();
  }
}

int questNum = 1;

class Quiz extends StatefulWidget {
  @override
  final int indice;

  Quiz({Key key, this.indice}) : super(key: key);
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<Question> _questions = <Question>[];
  Future<List<Question>> fetchQuestions() async {
    var url = Uri.parse('https://nadir-ogd.github.io/Quiz-API/questions.json'); //importation de contenu (questions + 4 propositions) en utilisant le fichier JSON
    var response = await http.get(url); //lien disponible sur la plateform Github (public)

// ignore: deprecated_member_use
    var questions = List<Question>();
    if (response.statusCode == 200) {
      var questionsJson = json.decode(response.body);
      for (var questionsJson in questionsJson) {
        questions.add(Question.fromJson(questionsJson));
      }
    }
    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/planetChoice');
      },
      child: ChangeNotifierProvider<Ind>(
          create: (context) => Ind(),
          child: Scaffold(
              backgroundColor: Colors.blue,
              body: FutureBuilder<List<Question>>(
                  future: fetchQuestions(),
                  builder: (context, AsyncSnapshot<List<Question>> snapshot) {
                    if (snapshot.hasData == false) {
                      return LoadingScreen();
                    }

                    ind = Provider.of<Ind>(context).ind;

                    if (cliquer == false) {
                      if (vfquestion == false) indices = [0, 1, 2, 3];
                      indices = shuffle(indices);//fonction qui mélange les indices du tableau (les réponses de chaque question sont affichés aléatoirement)
                      ind = shuffle(ind);//fonction qui mélange les indices du tableau (les questions de chaque planète sont affichés aléatoirement)
                    }
                    RemplirChoices(
                        propo, snapshot.data[ind[0] + 10 * planeteInd]);

                    planeteNAME =
                        snapshot.data[ind[0] + 10 * planeteInd].planete;

                    int i = 4;
                    if (propo[2] == null && propo[1] == null) { //le cas d'une question (avec vrai ou faux)
                      i = 2;
                      if (cliquer == false) indices = shuffle([0, 3]);
                      vfquestion = true;
                    }
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: myGradiant,
                          ),
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: AppbarCustomed(
                              myBlue: myBlue,
                              myRed2: myRed2,
                              planete: planeteNAME.inCaps,
                              numero: questNum,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 160),
                          child: Column(children: [
                            QuestBox(
                              quest: snapshot
                                  .data[ind[0] + 10 * planeteInd].question,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: min(4, i),
                                itemBuilder:
                                    (BuildContext context, int myindex) {
                                  return Column(children: [
                                    AnswerBox(
                                      answer: propo[indices[myindex]],
                                      answerLetter: '${myindex + 1}',
                                      infoSup: snapshot
                                          .data[ind[0] + 10 * planeteInd]
                                          .infosupp,
                                    ),
                                  ]);
                                },
                              ),
                            ),
                          ]),
                        ),
                      ],
                    );
                  }))),
    );
  }
}

class AnswerBox extends StatefulWidget {
  final String answer;
  final String answerLetter;
  final String infoSup;
  AnswerBox({
    Key key,
    this.answer: 'answer',
    this.answerLetter: 'A',
    this.infoSup,
  }) : super(key: key);

  @override
  _AnswerBoxState createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  void playRightMusic() async {
    rightAnswerPlayer.open(
      Audio(
        rightMusicPath,
      ),
      autoStart: true,
      playInBackground: PlayInBackground.disabledRestoreOnForeground,
    );
  }

  void playWrongMusic() async {
    rightAnswerPlayer.open(
      Audio(
        wrongMusicPath,
      ),
      autoStart: true,
      playInBackground: PlayInBackground.disabledRestoreOnForeground,
    );
  }

  bool recompCliquer = false;

  Color choiceColor = Colors.white;
  List<Color> choiceColors = [choiceGreen, choiceRed, choiceYellow, choiceBlue];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 22, left: 20, right: 20),
          child: Container(
            width: double.infinity,
            height: 69,
            decoration: BoxDecoration(
              color: choiceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: ListTile(
                onTap: () {
                  recompCliquer = cliquer;

                  if (widget.answer == propo[0]) {
                    setState(() {
                      playRightMusic();

                      if (cliquer == false) {
                        points += factRecomp;
                        etoiles = points;
                      }
                      verefication = true;

                      etoiles = points;

                      choiceColor = choiceColors[0];
                      questNum++;

                      showDialog(//afficher la fenetre qui contient les infos complémentaire lorsque l'utilisateur réponds à une question quelconque
                        barrierDismissible: ind.length != 1,
                        context: context,
                        builder: (context) => InfoSup(
                          content: widget.infoSup,
                          recomp: recompCliquer ? 0 : factRecomp,
                          onPressedExiste: ind.length == 0,
                          onPressed: () {
                            verefier = verification(etoiles);

                            update();//mettre la trace à jour (les points ajoutés)
                            user.etoiles = trace.earth +
                                trace.jupiter +
                                trace.mars +
                                trace.mercury +
                                trace.neptune +
                                trace.saturn +
                                trace.soleil +
                                trace.uranus +
                                trace.venus;

                            Navigator.pushReplacementNamed(
                                context, '/bravoNiveau');
                          },
                        ),
                      );

                      ind.removeAt(0);//enlever l'indice de la question répondu du tableau (arreter lorque le tableau est vide : 10 questions répondues)
                      vfquestion = false;
                      cliquer = false;
                    });
                    //mettre la couleur, les étoiles et le nombre de tentatives à jour
                  } else if (widget.answer == propo[1]) 
                    setState(() {
                      verefication = false;
                      playWrongMusic();
                      cliquer = true;
                      choiceColor = choiceColors[1];
                      nbTentatives--;
                      Provider.of<Ind>(context, listen: false)
                          .updateInd(ind, nbTentatives);
                    });
                  else if (widget.answer == propo[2])
                    setState(() {
                      verefication = false;
                      playWrongMusic();
                      cliquer = true;
                      choiceColor = choiceColors[2];
                      nbTentatives--;
                      Provider.of<Ind>(context, listen: false)
                          .updateInd(ind, nbTentatives);
                    });
                  else if (widget.answer == propo[3]) {
                    setState(() {
                      verefication = false;
                      playWrongMusic();
                      cliquer = true;
                      choiceColor = choiceColors[3];
                      nbTentatives--;
                      Provider.of<Ind>(context, listen: false)
                          .updateInd(ind, nbTentatives);
                    });
                  }

                  Timer(Duration(milliseconds: 600), () {
                    setState(() {
                      choiceColor = Colors.white;
                    });
                  });

                  Timer(Duration(seconds: 1), () {
                    if (ind.isEmpty || nbTentatives <= 0) {
                      if (verefication == true) {
                        if (verefier == 1) {
                          update();

                          user.etoiles = trace.earth +
                              trace.jupiter +
                              trace.mars +
                              trace.mercury +
                              trace.neptune +
                              trace.saturn +
                              trace.soleil +
                              trace.uranus +
                              trace.venus;
                        }
                      } else {
                        if (verification(points) == 1) {
                          update();

                          user.etoiles = trace.earth +
                              trace.jupiter +
                              trace.mars +
                              trace.mercury +
                              trace.neptune +
                              trace.saturn +
                              trace.soleil +
                              trace.uranus +
                              trace.venus;
                        }
                      }
                      etoiles = points;
                      if (nbTentatives <= 0) {
                        indicesbr = planeteInd;
                        points = 0;
                        Navigator.pushReplacementNamed(context, '/bravoNiveau');
                      }
                      indicesbr = planeteInd;
                      //Navigator.pushReplacementNamed(context, '/planetChoice');
                      questNum = 1;
                      points = 0;
                    } else {
                      if (widget.answer == propo[0]) {
                        setState(() {
                          Provider.of<Ind>(context, listen: false)
                              .updateInd(ind, nbTentatives);
                        });
                      }
                    }
                  });
                },
                selectedTileColor: choiceColor,
                leading: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, bottom: 8, right: 15),
                  child: Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      color: myRed2,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.answerLetter}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '${widget.answer}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class QuestBox extends StatelessWidget {
  const QuestBox({
    this.quest: 'Quelle est la couleur du Soleil',
    Key key,
  }) : super(key: key);

  final String quest;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: myRed2,
          child: Center(
            child: Text(
              '$quest',
              style: TextStyle(
                fontFamily: 'Gotham',
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 19,
              ),
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class AppbarCustomed extends StatelessWidget {
  const AppbarCustomed({
    Key key,
    @required this.myBlue,
    @required this.myRed2,
    this.planete: 'Soleil',
    this.numero: 5,
  }) : super(key: key);

  final Color myBlue;
  final Color myRed2;
  final String planete;
  final int numero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 91,
          elevation: 20,
          title: Container(
            clipBehavior: Clip.none,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$planete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '$numero/10',
                  style: TextStyle(
                    color: myRed2,
                    fontSize: 17,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          leadingWidth: 70,
          leading: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(children: [
                Text(
                  '${Provider.of<Ind>(context).nb}',
                  style: TextStyle(
                    color: myRed2,
                    fontSize: 23,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 3),
                  child: Transform.rotate(
                    angle: 6.5,
                    child: Image.asset(
                      'assets/images/icons/fusil.png',
                      fit: BoxFit.scaleDown,
                      width: 15,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          actions: [
            Center(
              child: IconButton(
                  icon: Icon(Icons.clear),
                  color: myRed2,
                  iconSize: 30,
                  onPressed: () {
                    points = 0;
                    Navigator.pushReplacementNamed(context, '/planetChoice');
                  }),
            ),
          ],
        ));
  }
}

class ProgressBar extends StatelessWidget {
  final double width;
// final int value;
// final int totalValue;

  ProgressBar({this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 5,
        ),
        Stack(
          children: <Widget>[
            Container(
              width: width,
              height: 8,
              decoration: BoxDecoration(color: myBlue),
            ),
            Row(
              children: [
                AnimatedContainer(
                  height: 8,
                  width: width,
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: myRed2,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

void RemplirChoices(List<String> choices, Question myquestion) { //une fonction qui permet de remplir le tableau des indices des 4 réponses d'une question à partir de fichier JSON
  choices[0] = myquestion.correct;
  choices[1] = myquestion.choice1;
  choices[2] = myquestion.choice2;
  choices[3] = myquestion.choice3;
}

List shuffle(List<int> indices) {//fonction qui mélange les indices d'un tableau donné (pour que les réponses et les questions seront toujours affichées aléatoirement)
  var random = new Random();

  // Go through all elements.
  for (var i = indices.length - 1; i >= 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);
    var temp = indices[i];
    indices[i] = indices[n];
    indices[n] = temp;
  }

  return indices;
}

int verification(int point) {//vérification l'ancien nombre d'étoiles colléctées avec le nouveau et mettre la trace à jour
  if (planeteInd == 0) {
    if (trace.soleil < point) {
      difference = point - trace.soleil;

      trace.soleil = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.soleil;
      return -1;
    }
  }
  if (planeteInd == 1) {
    if (trace.mercury < point) {
      difference = point - trace.mercury;

      trace.mercury = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.mercury;
      return -1;
    }
  }
  if (planeteInd == 2) {
    if (trace.venus < point) {
      difference = point - trace.venus;

      trace.venus = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.venus;
      return -1;
    }
  }
  if (planeteInd == 3) {
    if (trace.earth < point) {
      difference = point - trace.earth;

      trace.earth = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.earth;
      return -1;
    }
  }
  if (planeteInd == 4) {
    if (trace.mars < point) {
      difference = point - trace.mars;

      trace.mars = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.mars;
      return -1;
    }
  }
  if (planeteInd == 5) {
    if (trace.jupiter < point) {
      difference = point - trace.jupiter;

      trace.jupiter = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.jupiter;
      return -1;
    }
  }
  if (planeteInd == 6) {
    if (trace.saturn < point) {
      difference = point - trace.saturn;

      trace.saturn = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.saturn;
      return -1;
    }
  }
  if (planeteInd == 7) {
    if (trace.uranus < point) {
      difference = point - trace.uranus;

      trace.uranus = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.uranus;
      return -1;
    }
  }
  if (planeteInd == 8) {
    if (trace.neptune < point) {
      difference = point - trace.neptune;

      trace.neptune = point;
      etoilesMax = point;
      return 1;
    } else {
      difference = 0;
      etoilesMax = trace.neptune;
      return -1;
    }
  }
}

void update() async {//mettre la trace d'utilisateur à jour
  await supabaseclient
      .from("Trace")
      .update({
        "email": user.email,
        "jupiter": trace.jupiter,
        "earth": trace.earth,
        "venus": trace.venus,
        "soleil": trace.soleil,
        "uranus": trace.uranus,
        "saturn": trace.saturn,
        "neptune": trace.neptune,
        "mercury": trace.mercury,
        "mars": trace.mars
      })
      .eq("email", user.email)
      .execute();
  await supabaseclient
      .from("user")
      .update({
        "etoiles": trace.earth +
            trace.jupiter +
            trace.mars +
            trace.mercury +
            trace.neptune +
            trace.saturn +
            trace.soleil +
            trace.uranus +
            trace.venus,
      })
      .eq("email", user.email)
      .execute();
}
