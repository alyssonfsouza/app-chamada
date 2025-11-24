import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaChamada extends StatefulWidget {
  
  final String turmaSelecionada;

  
  const TelaChamada({super.key, required this.turmaSelecionada});

  @override
  State<TelaChamada> createState() => _TelaChamadaState();
}

class _TelaChamadaState extends State<TelaChamada> {
  
  final _db = FirebaseFirestore.instance;

  
  List<QueryDocumentSnapshot> _alunos = [];

  
  final Map<String, String> _statusChamada = {};

  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _carregarAlunosDaTurma();
  }

  
  void _carregarAlunosDaTurma() async {
    final snapshot = await _db
        .collection('alunos')
        .where('turma', isEqualTo: widget.turmaSelecionada)
        .orderBy('nome')
        .get();

    setState(() {
      _alunos = snapshot.docs;
      
      for (var aluno in _alunos) {
        _statusChamada[aluno.id] = 'presente';
      }
      _isLoading = false;
    });
  }

  
  void _salvarFrequencia() async {
    
    final dataHoje = DateTime.now().toIso8601String().split('T').first;

    
    final batch = _db.batch();

    
    int presentes = 0;
    int faltas = 0;
    

    for (var aluno in _alunos) {
      final alunoId = aluno.id;
      final dadosAluno = aluno.data() as Map<String, dynamic>;
      final status = _statusChamada[alunoId] ?? 'ausente';

      
      if (status == 'presente') {
        presentes++;
      } else {
        faltas++;
      }
      

      
      final novoRegistro = _db.collection('frequencia').doc();
      batch.set(novoRegistro, {
        'alunoId': alunoId,
        'alunoNome': dadosAluno['nome'],
        'turma': dadosAluno['turma'],
        'data': dataHoje,
        'status': status,
      });
    }

    
    await batch.commit();

    
    if (!context.mounted) return;

    
    final mensagem = 'Frequência salva: $presentes presentes, $faltas faltas.';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
    

    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamada - Turma A'),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar Frequência',
            onPressed: _salvarFrequencia, 
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              itemCount: _alunos.length,
              itemBuilder: (context, index) {
                final aluno = _alunos[index];
                final dados = aluno.data() as Map<String, dynamic>;
                final alunoId = aluno.id;

                
                return ListTile(
                  title: Text(dados['nome']),
                  subtitle: Text('Matrícula: ${dados['matricula']}'),
                  
                  
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'presente', label: Text('P')),
                      ButtonSegment(value: 'ausente', label: Text('F')), 
                    ],
                    selected: {_statusChamada[alunoId]!},
                    onSelectionChanged: (Set<String> novoStatus) {
                      
                      setState(() {
                        _statusChamada[alunoId] = novoStatus.first;
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}