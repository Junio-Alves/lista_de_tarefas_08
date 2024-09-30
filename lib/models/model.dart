class Tarefa {
  String nome;
  bool realizada;
  Tarefa({
    required this.nome,
    required this.realizada,
  });

  //transforma o objeto em json
  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "realizada": realizada.toString(),
    };
  }

  //transforma json em objeto
  factory Tarefa.fromJson(Map<String, dynamic> json) {
    // json = {"nome":"teste","realizada":"false"}
    return Tarefa(
      nome: json["nome"],
      realizada: json["realizada"] == "true" ? true : false,
    );
  }
}
