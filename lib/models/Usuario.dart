class Usuario {
  String? _uidUsuario;
  String? _nome;
  String? _email;
  String? _senha;

  Usuario();
  Map<String, dynamic> toMpa() {
    Map<String, dynamic> map = {
      "idUsuario": this.uidUsuario,
      "nome": this.nome,
      "email": this.email
    };
    return map;
  }

  get uidUsuario => this._uidUsuario;

  set uidUsuario(value) => this._uidUsuario = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get email => this._email;

  set email(value) => this._email = value;

  get senha => this._senha;

  set senha(value) => this._senha = value;
}
