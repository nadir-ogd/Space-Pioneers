// import 'dart:js';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:astro01/Screens/OriginalSplashScreen.dart';
import 'package:astro01/Screens/bravoBadge.dart';
import 'package:astro01/Screens/bravoNiveau.dart';
import 'package:astro01/Screens/levelChoice.dart';

import 'package:astro01/Screens/quiz.dart';
import 'package:astro01/Screens/randomSection.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';
import 'Screens/bravoNiveauR.dart';
import 'Screens/guide.dart';
import 'Screens/inscription.dart';
import 'Screens/loading.dart';
import 'Screens/quiz.dart';
import 'Screens/splashScreen.dart';
import 'Screens/testing.dart';
import 'Screens/login.dart';
import 'Screens/leaderBoard.dart';
import 'components/constants.dart';
import 'Screens/homeScreen.dart';
import 'Screens/shopPage.dart';
import 'Screens/avatarPage.dart';
import 'Screens/profilePage.dart';
import 'Screens/planetChoice.dart';
import 'Screens/documentation_swiper.dart';
import 'Screens/levelChoiceRandom.dart';

// la page main pour definir les deffirentes routes de l'application et ele est la page du demarage de l'app
const supabaseUrl = 'https://ltsahdljhuochhecajen.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMDQ3OTY4MiwiZXhwIjoxOTM2MDU1NjgyfQ.IoKgpB9APMw5Te9DYgbJZIbYcvPOwl41dl4-IKFjpVk';
final supabaseclient = SupabaseClient(supabaseUrl, supabaseKey);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Injector.appInstance.registerSingleton<SupabaseClient>(() => supabaseclient);
  AssetsAudioPlayer mainAudioPlayer = AssetsAudioPlayer();
  AssetsAudioPlayer docAudioPlayer = AssetsAudioPlayer();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Gotham', //setting default font
      primaryColor: myBlue,
      // 0xffe6023d
      // to change calendar color
      primarySwatch: calendarColor,
    ),
    initialRoute: '/splash', // initialisation de la route
    routes: {
      '/splashScreen': (context) =>
          SplashScreen(), // definition eds autres routes
      '/splash': (context) => Splash(
            mainAudioPlayer: mainAudioPlayer,
          ),
      '/inscription': (context) => Inscription(),
      '/login': (context) => Login(),
      '/leaderBoard': (context) => LeaderBoard(),
      '/homeScreen': (context) => HomeScreen(
            mainAudioPlayer: mainAudioPlayer,
          ),
      '/shopPage': (context) => ShopPage(),
      '/avatarPage': (context) => AvatarPage(),
      '/profilePage': (context) => ProfilePage(),
      '/planetChoice': (context) => PlanetChoice(),
      '/levelChoice': (context) => LevelChoice(),
      '/testing': (context) => Testing(),
      '/quiz': (context) => Quiz(),
      '/loadingScreen': (context) => LoadingScreen(),
      '/documentation': (context) => Documentation(
            docAudioPlayer: docAudioPlayer,
            mainAudioPlayer: mainAudioPlayer,
          ),
      '/bravoNiveau': (context) => BravoNiveau(),
      '/bravoNiveauR': (context) => BravoNiveauR(),
      '/bravoBadge': (context) => BravoBadge(),
      '/random': (context) => RandomQuiz(),
      '/levelChoiceRandom': (context) => LevelChoiceRandom(),
      '/guide': (context) => Guide(),
    },
  ));
}
