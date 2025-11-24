import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_chamada.dart';

class TelaSelecaoTurma extends StatefulWidget {
  const TelaSelecaoTurma({super.key});

  @override
  State<TelaSelecaoTurma> createState() => _TelaSelecaoTurmaState();
}

class _TelaSelecaoTurmaState extends State<TelaSelecaoTurma> {
  final _db = FirebaseFirestore.instance;
  List<String> _turmas = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTurmas();
  }

  
  void _carregarTurmas() async {
    final snapshot = await _db.collection('alunos').get();

    
    
    final setDeTurmas = <String>{};

    for (var doc in snapshot.docs) {
      final dados = doc.data();
      if (dados.containsKey('turma')) {
        setDeTurmas.add(dados['turma'] as String);
      }
    }

    
    setState(() {
      _turmas = setDeTurmas.toList()..sort();
      _isLoading = false;
    });
  }

  
  void _selecionarTurma(String turma) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        
        builder: (context) => TelaChamada(turmaSelecionada: turma),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Turma'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _turmas.length,
              itemBuilder: (context, index) {
                final turma = _turmas[index];
                return ListTile(
                  title: Text(turma),
                  onTap: () => _selecionarTurma(turma),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
    );
  }
}