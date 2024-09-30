import 'package:flutter/material.dart';
import 'package:myapp/models/model.dart';
import 'package:myapp/shared_prefs/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  final sharedPrefs = SharedPrefs();

  List<Tarefa> tarefas = [];
  
  //Salva toda modificação de tarefas dentro do sharedPreferences
  salvarDados() {
    sharedPrefs.salvarDados(tarefas);
  }

  recuperarDados() async {
    final tarefasRecuperadas = await sharedPrefs.recuperarDados();
    setState(() {
      tarefas = tarefasRecuperadas;
    });
  }

  adicionarTarefa() {
    setState(() {
      tarefas.add(Tarefa(nome: textController.text, realizada: false));
    });
    salvarDados();
  }

  marcarStatus(bool value, int index) {
    setState(() {
      tarefas[index].realizada = value;
      salvarDados();
    });
  }

  @override
  void initState() {
    recuperarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Lista de Tarefas",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Adicionar Tarefa"),
                content: TextFormField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: "Digite sua tarefa",
                  ),
                ),
                actions: [
                  //Cancelar ação
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                    ),
                  ),
                  //Confirmar Ação
                  TextButton(
                    onPressed: () {
                      adicionarTarefa();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Salvar",
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: criarItemLista,
            ),
          ),
        ],
      ),
    );
  }

  
  //cria listagem de itens com dismissible
  Widget criarItemLista(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        //salvar copia da tarefa
        final tarefaBackup = tarefas[index];
        //remove da lista
        tarefas.removeAt(index);

        final snackBar = SnackBar(
          duration: const Duration(seconds: 5),
          content: const Text("Tarefa Removida"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                //adiciona na lista novamente
                setState(() {
                  tarefas.insert(index, tarefaBackup);
                });
              }),
        );
        //mostra a mensagem
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        salvarDados();
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: CheckboxListTile(
        value: tarefas[index].realizada,
        onChanged: (value) {
          marcarStatus(value!, index);
        },
        title: Text(
          tarefas[index].nome,
        ),
      ),
    );
  }
}
