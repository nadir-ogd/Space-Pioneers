import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:astro01/classes/User.dart';
import 'package:astro01/classes/trace.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

Users user = new Users();
Trace trace = new Trace();
bool mute = false;
int indice = 0;
int nbTentatives;
int factRecomp;
bool ableToBadge = false;
