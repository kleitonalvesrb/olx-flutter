import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';
import 'package:olx/views/widgets/InputCustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<File> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;
  Anuncio? _anuncio;
  BuildContext? _dialogContext;

  _selecionarImagemGaleria() async {
    final ImagePicker _picker = ImagePicker();

    // Pick an image
    // final File? imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);

    // File imagemSelecionada = (await ImagePicker().pickImage(source: ImageSource.gallery)) as File;
    PickedFile? imagemSeelcionada =
        await _picker.getImage(source: ImageSource.gallery);
    if (imagemSeelcionada != null) {
      setState(() {
        _listaImagens.add(File(imagemSeelcionada.path));
      });
    }
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext!);
    await _uploadImagens();
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    String idUsuarioLogado = usuarioLogado.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio!.id)
        .set(_anuncio!.toMap())
        .then((_) {
          
      Navigator.pop(_dialogContext!);
      Navigator.pushReplacementNamed(context, "/meus-anuncios");
    });
    // CollectionReference anuncios = db.collection("meus_anuncios");
    print("lista de images: ${_anuncio!.fotos.toString()}");
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Salvando anúncio...")
            ]),
          );
        });
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio!.id)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => print("salvou"));
      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio!.fotos.add(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregaritensDropDown();
    _anuncio = Anuncio();
  }

  _carregaritensDropDown() {
    //estados
    for (var estado in Estados.listaEstadosSigla) {
      _listaItensDropEstados
          .add(DropdownMenuItem(child: Text(estado), value: estado));
    }

    //categorias
    _listaItensDropCategorias.add(const DropdownMenuItem(
      child: Text("Automóvel"),
      value: "auto",
    ));

    _listaItensDropCategorias.add(const DropdownMenuItem(
      child: Text("Imóvel"),
      value: "imovel",
    ));
    _listaItensDropCategorias.add(const DropdownMenuItem(
      child: Text("Eletrônicos"),
      value: "eletro",
    ));
    _listaItensDropCategorias.add(const DropdownMenuItem(
      child: Text("Moda"),
      value: "moda",
    ));
    _listaItensDropCategorias.add(const DropdownMenuItem(
      child: Text("Esportes"),
      value: "esporte",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens!.isEmpty) {
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _listaImagens.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                  color: Colors.grey[100]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {}
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.file(
                                                        _listaImagens[indice]),
                                                    FlatButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _listaImagens
                                                              .removeAt(indice);
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                      child:
                                                          const Text("Excluir"),
                                                      textColor: Colors.red,
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          FileImage(_listaImagens[indice]),
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.2),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: const Text("Estados"),
                          onSaved: (estado) {
                            _anuncio!.estado = estado;
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          items: _listaItensDropEstados,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String?);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor as String?;
                            });
                          },
                        ),
                      ),
                    ),
                    // categoria
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: const Text("Categoria"),
                          onSaved: (categoria) {
                            _anuncio!.categoria = categoria;
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          items: _listaItensDropCategorias,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String?);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor as String?;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    obscure: false,
                    autofocus: false,
                    hint: "Título",
                    onSaved: (titulo) {
                      _anuncio!.titulo = titulo;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    obscure: false,
                    autofocus: false,
                    type: TextInputType.number,
                    hint: "Preço",
                    onSaved: (preco) {
                      _anuncio!.preco = preco;
                    },
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(
                        moeda: true,
                      )
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    obscure: false,
                    autofocus: false,
                    type: TextInputType.phone,
                    hint: "Telefone",
                    onSaved: (telefone) {
                      _anuncio!.telefone = telefone;
                    },
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    obscure: false,
                    autofocus: false,
                    // type: TextInputType.phone,
                    hint: "Descrição (200 caracteres)",
                    onSaved: (descricao) {
                      _anuncio!.descricao = descricao;
                    },
                    maxLines: null,
                    // inputFormatter: [
                    //   FilteringTextInputFormatter.digitsOnly,
                    //   TelefoneInputFormatter()SS
                    // ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      _dialogContext = context;
                      _salvarAnuncio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
