// Import da nova tela de detalhes
import 'tela_detalhe.dart'; 
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TelaLista extends StatelessWidget {
  const TelaLista({super.key});

  @override
  Widget build(BuildContext context) {
    
    final _db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos'),
      ),
    
      body: StreamBuilder<QuerySnapshot>(
        
        
        stream: _db.collection('alunos').orderBy('nome').snapshots(),

        
        builder: (context, snapshot) {
          
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum aluno cadastrado.'));
          }

          final alunos = snapshot.data!.docs;

          
          return ListView.builder(
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              
              final aluno = alunos[index];
              
              final dados = aluno.data() as Map<String, dynamic>;

              
              return ListTile(
                title: Text(dados['nome']),
                subtitle: Text('Matrícula: ${dados['matricula']} - Turma: ${dados['turma']}'),
                

                onTap: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      
                      builder: (context) => TelaDetalhe(alunoId: aluno.id),
                    ),
                  );
                },
                
              );
            },
          );
        },
      ),
    );
  }
}