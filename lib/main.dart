import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Importar tela de cadastro
import 'tela_cadastro.dart'; 

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Chamada',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const TelaCadastro(), 
    );
  }
}