import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String? _id;
  String? _estado;
  String? _categoria;
  String? _titulo;
  String? _preco;
  String? _telefone;
  String? _descricao;
  List<String?>? _fotos = [];

  Anuncio() {
    // this.fotos = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    this.id = anuncios.doc().id; //10min
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "estado": estado,
      "categoria": categoria,
      "titulo": titulo,
      "preco": preco,
      "telefone": telefone,
      "descricao": descricao,
      "fotos": fotos
    };
    return map;
  }

  get id => this._id;

  set id(value) => this._id = value;

  get estado => this._estado;

  set estado(value) => this._estado = value;

  get categoria => this._categoria;

  set categoria(value) => this._categoria = value;

  get titulo => this._titulo;

  set titulo(value) => this._titulo = value;

  get preco => this._preco;

  set preco(value) => this._preco = value;

  get telefone => this._telefone;

  set telefone(value) => this._telefone = value;

  get descricao => this._descricao;

  set descricao(value) => this._descricao = value;

  get fotos => this._fotos;

  set fotos(value) => this._fotos = value;
}
