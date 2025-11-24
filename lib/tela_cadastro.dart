import 'tela_lista.dart';
// Importar a tela de SELEÇÃO
import 'tela_selecao_turma.dart'; 
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {

  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _turmaController = TextEditingController();


  final _db = FirebaseFirestore.instance;


  void _enviarDados() async {

    final nome = _nomeController.text;
    final matricula = _matriculaController.text;
    final turma = _turmaController.text;


    if (nome.isNotEmpty && matricula.isNotEmpty && turma.isNotEmpty) {

      await _db.collection('alunos').add({
        'nome': nome,
        'matricula': matricula,
        'turma': turma,
      });


      _nomeController.clear();
      _matriculaController.clear();
      _turmaController.clear();


      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno cadastrado com sucesso!')),
      );
    } else {

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Aluno'), 

        
        actions: [
          
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Ver Lista de Alunos',
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaLista()),
              );
            },
          ),
          
          
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: 'Fazer Chamada',
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaSelecaoTurma()),
              );
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Aluno',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            
            TextField(
              controller: _matriculaController,
              decoration: const InputDecoration(
                labelText: 'Número da Matrícula',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), 

            
            TextField(
              controller: _turmaController,
              decoration: const InputDecoration(
                labelText: 'Turma',
                border: OutlineInputBorder(), 
              ),
            ),
            const SizedBox(height: 32), 

            // O botão "Enviar"
            ElevatedButton(
              onPressed: _enviarDados, 
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}