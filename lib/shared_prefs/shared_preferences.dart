import 'dart:convert';

import 'package:myapp/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  salvarDados(List<Tarefa> tarefas) async {
    List<String> tarefasString = [];
    final prefs = await SharedPreferences.getInstance();
    /*Para cada tarefa em List<Tarefa> tarefas, converte de 
    Objeto -> Json -> String e adiciona List<String> tarefasString.
    */
    for (final tarefa in tarefas) {
      tarefasString.add(jsonEncode(tarefa.toJson()));
    }
    prefs.setStringList("tarefas", tarefasString);
  }

  Future<List<Tarefa>> recuperarDados() async {
    List<Tarefa> tarefas = [];
    final prefs = await SharedPreferences.getInstance();
    final tarefasJson = prefs.getStringList("tarefas");
    /* tarefasJson irá retornar algo tipo:
      {"nome":"teste","realizada":"true"},
      {"nome":"tarefa 2","realizada":"true"}
     */
    if (tarefasJson != null) {
      for (final tarefasString in tarefasJson) {
        tarefas.add(
          Tarefa.fromJson(
            jsonDecode(tarefasString),
          ),
        );
      }
    }
    return tarefas;
  }

  removerDados() {}
}
