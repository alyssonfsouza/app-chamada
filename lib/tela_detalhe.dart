import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaDetalhe extends StatefulWidget {
  
  final String alunoId;

  
  const TelaDetalhe({super.key, required this.alunoId});

  @override
  State<TelaDetalhe> createState() => _TelaDetalheState();
}

class _TelaDetalheState extends State<TelaDetalhe> {
  
  final _db = FirebaseFirestore.instance;

  
  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _turmaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _carregarDadosDoAluno();
  }

  
  void _carregarDadosDoAluno() async {
    
    final doc = await _db.collection('alunos').doc(widget.alunoId).get();
    
    
    if (doc.exists) {
      final dados = doc.data() as Map<String, dynamic>;
      
      _nomeController.text = dados['nome'];
      _matriculaController.text = dados['matricula'];
      _turmaController.text = dados['turma'];
    }
  }

  
  void _atualizarDados() async {
    final nome = _nomeController.text;
    final matricula = _matriculaController.text;
    final turma = _turmaController.text;

    if (nome.isNotEmpty && matricula.isNotEmpty && turma.isNotEmpty) {
      
      await _db.collection('alunos').doc(widget.alunoId).update({
        'nome': nome,
        'matricula': matricula,
        'turma': turma,
      });

      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno atualizado com sucesso!')),
      );
      Navigator.pop(context); 
    }
  }

  
  void _excluirDados() async {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este aluno?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                
                await _db.collection('alunos').doc(widget.alunoId).delete();
                
                
                Navigator.of(context).pop();
                
                Navigator.pop(context); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar/Editar Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Aluno'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _matriculaController,
              decoration: const InputDecoration(labelText: 'Número da Matrícula'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _turmaController,
              decoration: const InputDecoration(labelText: 'Turma'),
            ),
            const SizedBox(height: 32),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                ElevatedButton(
                  onPressed: _atualizarDados,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Salvar Edição'),
                ),
                
                ElevatedButton(
                  onPressed: _excluirDados,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}