import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:astro01/components/constants.dart';
import 'splashScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: myGradiant,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      AutoSizeText(
                        'Salut Anis !',
                        style: TextStyle(
                          color: myRed,
                          fontWeight: FontWeight.w900,
                          fontSize: 45,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        'Zinou nhar el lyoum mabrok idkom',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: -35,
                    right: -100,
                    child: Star(angle: 8, scale: 2.8),
                  ),
                  Positioned(
                    top: -50,
                    right: -10,
                    child: Star(angle: 8, scale: 2.8),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      SelectBox(
                        image: 'astroReading',
                        text: 'Decouvrire',
                        color: myRed,
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SelectBox(
                        image: 'ridingRocket',
                        text: 'Jouer',
                        color: Color(0xffAB02E6),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SelectBox(
                        image: 'ridingMoon',
                        text: 'Profile',
                        color: Color(0xff1759BC),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profilePage');
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: -70,
                    left: 50,
                    child: Star(angle: 8, scale: 2.8),
                  ),
                  Positioned(
                    bottom: -50,
                    right: 10,
                    child: Star(angle: 8, scale: 2.8),
                  ),
                  Positioned(
                    bottom: 130,
                    left: 0,
                    child: Star(angle: 8, scale: 2.8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectBox extends StatelessWidget {
  SelectBox({Key key, this.color, this.image, this.text, this.onPressed})
      : super(key: key);
  final String image;
  final String text;
  final Color color;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: color,
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/other/$image.png'),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: AutoSizeText(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
