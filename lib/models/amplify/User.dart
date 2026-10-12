/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _perfil;
  final String? _email;
  final String? _telefone;
  final String? _endereco_texto;
  final double? _latitude;
  final double? _longitude;
  final String? _nome;
  final String? _cpf;
  final List<String>? _escopo_operario;
  final String? _nivel_operario;
  final String? _nivel_de_experiencia_sistema;
  final int? _quantidade_servicos_realizados;
  final int? _raio_atendimento_km;
  final String? _portfolio_url;
  final String? _experiencias_anteriores;
  final String? _nome_instituicao;
  final String? _cnpj;
  final String? _tipo_entidade;
  final String? _estatuto_social_url;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String get perfil {
    try {
      return _perfil!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get telefone {
    try {
      return _telefone!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get endereco_texto {
    try {
      return _endereco_texto!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get latitude {
    return _latitude;
  }
  
  double? get longitude {
    return _longitude;
  }
  
  String? get nome {
    return _nome;
  }
  
  String? get cpf {
    return _cpf;
  }
  
  List<String>? get escopo_operario {
    return _escopo_operario;
  }
  
  String? get nivel_operario {
    return _nivel_operario;
  }
  
  String? get nivel_de_experiencia_sistema {
    return _nivel_de_experiencia_sistema;
  }
  
  int? get quantidade_servicos_realizados {
    return _quantidade_servicos_realizados;
  }
  
  int? get raio_atendimento_km {
    return _raio_atendimento_km;
  }
  
  String? get portfolio_url {
    return _portfolio_url;
  }
  
  String? get experiencias_anteriores {
    return _experiencias_anteriores;
  }
  
  String? get nome_instituicao {
    return _nome_instituicao;
  }
  
  String? get cnpj {
    return _cnpj;
  }
  
  String? get tipo_entidade {
    return _tipo_entidade;
  }
  
  String? get estatuto_social_url {
    return _estatuto_social_url;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, required perfil, required email, required telefone, required endereco_texto, latitude, longitude, nome, cpf, escopo_operario, nivel_operario, nivel_de_experiencia_sistema, quantidade_servicos_realizados, raio_atendimento_km, portfolio_url, experiencias_anteriores, nome_instituicao, cnpj, tipo_entidade, estatuto_social_url, createdAt, updatedAt}): _perfil = perfil, _email = email, _telefone = telefone, _endereco_texto = endereco_texto, _latitude = latitude, _longitude = longitude, _nome = nome, _cpf = cpf, _escopo_operario = escopo_operario, _nivel_operario = nivel_operario, _nivel_de_experiencia_sistema = nivel_de_experiencia_sistema, _quantidade_servicos_realizados = quantidade_servicos_realizados, _raio_atendimento_km = raio_atendimento_km, _portfolio_url = portfolio_url, _experiencias_anteriores = experiencias_anteriores, _nome_instituicao = nome_instituicao, _cnpj = cnpj, _tipo_entidade = tipo_entidade, _estatuto_social_url = estatuto_social_url, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, required String perfil, required String email, required String telefone, required String endereco_texto, double? latitude, double? longitude, String? nome, String? cpf, List<String>? escopo_operario, String? nivel_operario, String? nivel_de_experiencia_sistema, int? quantidade_servicos_realizados, int? raio_atendimento_km, String? portfolio_url, String? experiencias_anteriores, String? nome_instituicao, String? cnpj, String? tipo_entidade, String? estatuto_social_url}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      perfil: perfil,
      email: email,
      telefone: telefone,
      endereco_texto: endereco_texto,
      latitude: latitude,
      longitude: longitude,
      nome: nome,
      cpf: cpf,
      escopo_operario: escopo_operario != null ? List<String>.unmodifiable(escopo_operario) : escopo_operario,
      nivel_operario: nivel_operario,
      nivel_de_experiencia_sistema: nivel_de_experiencia_sistema,
      quantidade_servicos_realizados: quantidade_servicos_realizados,
      raio_atendimento_km: raio_atendimento_km,
      portfolio_url: portfolio_url,
      experiencias_anteriores: experiencias_anteriores,
      nome_instituicao: nome_instituicao,
      cnpj: cnpj,
      tipo_entidade: tipo_entidade,
      estatuto_social_url: estatuto_social_url);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _perfil == other._perfil &&
      _email == other._email &&
      _telefone == other._telefone &&
      _endereco_texto == other._endereco_texto &&
      _latitude == other._latitude &&
      _longitude == other._longitude &&
      _nome == other._nome &&
      _cpf == other._cpf &&
      DeepCollectionEquality().equals(_escopo_operario, other._escopo_operario) &&
      _nivel_operario == other._nivel_operario &&
      _nivel_de_experiencia_sistema == other._nivel_de_experiencia_sistema &&
      _quantidade_servicos_realizados == other._quantidade_servicos_realizados &&
      _raio_atendimento_km == other._raio_atendimento_km &&
      _portfolio_url == other._portfolio_url &&
      _experiencias_anteriores == other._experiencias_anteriores &&
      _nome_instituicao == other._nome_instituicao &&
      _cnpj == other._cnpj &&
      _tipo_entidade == other._tipo_entidade &&
      _estatuto_social_url == other._estatuto_social_url;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("perfil=" + "$_perfil" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("telefone=" + "$_telefone" + ", ");
    buffer.write("endereco_texto=" + "$_endereco_texto" + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("nome=" + "$_nome" + ", ");
    buffer.write("cpf=" + "$_cpf" + ", ");
    buffer.write("escopo_operario=" + (_escopo_operario != null ? _escopo_operario!.toString() : "null") + ", ");
    buffer.write("nivel_operario=" + "$_nivel_operario" + ", ");
    buffer.write("nivel_de_experiencia_sistema=" + "$_nivel_de_experiencia_sistema" + ", ");
    buffer.write("quantidade_servicos_realizados=" + (_quantidade_servicos_realizados != null ? _quantidade_servicos_realizados!.toString() : "null") + ", ");
    buffer.write("raio_atendimento_km=" + (_raio_atendimento_km != null ? _raio_atendimento_km!.toString() : "null") + ", ");
    buffer.write("portfolio_url=" + "$_portfolio_url" + ", ");
    buffer.write("experiencias_anteriores=" + "$_experiencias_anteriores" + ", ");
    buffer.write("nome_instituicao=" + "$_nome_instituicao" + ", ");
    buffer.write("cnpj=" + "$_cnpj" + ", ");
    buffer.write("tipo_entidade=" + "$_tipo_entidade" + ", ");
    buffer.write("estatuto_social_url=" + "$_estatuto_social_url" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? perfil, String? email, String? telefone, String? endereco_texto, double? latitude, double? longitude, String? nome, String? cpf, List<String>? escopo_operario, String? nivel_operario, String? nivel_de_experiencia_sistema, int? quantidade_servicos_realizados, int? raio_atendimento_km, String? portfolio_url, String? experiencias_anteriores, String? nome_instituicao, String? cnpj, String? tipo_entidade, String? estatuto_social_url}) {
    return User._internal(
      id: id,
      perfil: perfil ?? this.perfil,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      endereco_texto: endereco_texto ?? this.endereco_texto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      escopo_operario: escopo_operario ?? this.escopo_operario,
      nivel_operario: nivel_operario ?? this.nivel_operario,
      nivel_de_experiencia_sistema: nivel_de_experiencia_sistema ?? this.nivel_de_experiencia_sistema,
      quantidade_servicos_realizados: quantidade_servicos_realizados ?? this.quantidade_servicos_realizados,
      raio_atendimento_km: raio_atendimento_km ?? this.raio_atendimento_km,
      portfolio_url: portfolio_url ?? this.portfolio_url,
      experiencias_anteriores: experiencias_anteriores ?? this.experiencias_anteriores,
      nome_instituicao: nome_instituicao ?? this.nome_instituicao,
      cnpj: cnpj ?? this.cnpj,
      tipo_entidade: tipo_entidade ?? this.tipo_entidade,
      estatuto_social_url: estatuto_social_url ?? this.estatuto_social_url);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String>? perfil,
    ModelFieldValue<String>? email,
    ModelFieldValue<String>? telefone,
    ModelFieldValue<String>? endereco_texto,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<String?>? nome,
    ModelFieldValue<String?>? cpf,
    ModelFieldValue<List<String>?>? escopo_operario,
    ModelFieldValue<String?>? nivel_operario,
    ModelFieldValue<String?>? nivel_de_experiencia_sistema,
    ModelFieldValue<int?>? quantidade_servicos_realizados,
    ModelFieldValue<int?>? raio_atendimento_km,
    ModelFieldValue<String?>? portfolio_url,
    ModelFieldValue<String?>? experiencias_anteriores,
    ModelFieldValue<String?>? nome_instituicao,
    ModelFieldValue<String?>? cnpj,
    ModelFieldValue<String?>? tipo_entidade,
    ModelFieldValue<String?>? estatuto_social_url
  }) {
    return User._internal(
      id: id,
      perfil: perfil == null ? this.perfil : perfil.value,
      email: email == null ? this.email : email.value,
      telefone: telefone == null ? this.telefone : telefone.value,
      endereco_texto: endereco_texto == null ? this.endereco_texto : endereco_texto.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      nome: nome == null ? this.nome : nome.value,
      cpf: cpf == null ? this.cpf : cpf.value,
      escopo_operario: escopo_operario == null ? this.escopo_operario : escopo_operario.value,
      nivel_operario: nivel_operario == null ? this.nivel_operario : nivel_operario.value,
      nivel_de_experiencia_sistema: nivel_de_experiencia_sistema == null ? this.nivel_de_experiencia_sistema : nivel_de_experiencia_sistema.value,
      quantidade_servicos_realizados: quantidade_servicos_realizados == null ? this.quantidade_servicos_realizados : quantidade_servicos_realizados.value,
      raio_atendimento_km: raio_atendimento_km == null ? this.raio_atendimento_km : raio_atendimento_km.value,
      portfolio_url: portfolio_url == null ? this.portfolio_url : portfolio_url.value,
      experiencias_anteriores: experiencias_anteriores == null ? this.experiencias_anteriores : experiencias_anteriores.value,
      nome_instituicao: nome_instituicao == null ? this.nome_instituicao : nome_instituicao.value,
      cnpj: cnpj == null ? this.cnpj : cnpj.value,
      tipo_entidade: tipo_entidade == null ? this.tipo_entidade : tipo_entidade.value,
      estatuto_social_url: estatuto_social_url == null ? this.estatuto_social_url : estatuto_social_url.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _perfil = json['perfil'],
      _email = json['email'],
      _telefone = json['telefone'],
      _endereco_texto = json['endereco_texto'],
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _nome = json['nome'],
      _cpf = json['cpf'],
      _escopo_operario = json['escopo_operario']?.cast<String>(),
      _nivel_operario = json['nivel_operario'],
      _nivel_de_experiencia_sistema = json['nivel_de_experiencia_sistema'],
      _quantidade_servicos_realizados = (json['quantidade_servicos_realizados'] as num?)?.toInt(),
      _raio_atendimento_km = (json['raio_atendimento_km'] as num?)?.toInt(),
      _portfolio_url = json['portfolio_url'],
      _experiencias_anteriores = json['experiencias_anteriores'],
      _nome_instituicao = json['nome_instituicao'],
      _cnpj = json['cnpj'],
      _tipo_entidade = json['tipo_entidade'],
      _estatuto_social_url = json['estatuto_social_url'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'perfil': _perfil, 'email': _email, 'telefone': _telefone, 'endereco_texto': _endereco_texto, 'latitude': _latitude, 'longitude': _longitude, 'nome': _nome, 'cpf': _cpf, 'escopo_operario': _escopo_operario, 'nivel_operario': _nivel_operario, 'nivel_de_experiencia_sistema': _nivel_de_experiencia_sistema, 'quantidade_servicos_realizados': _quantidade_servicos_realizados, 'raio_atendimento_km': _raio_atendimento_km, 'portfolio_url': _portfolio_url, 'experiencias_anteriores': _experiencias_anteriores, 'nome_instituicao': _nome_instituicao, 'cnpj': _cnpj, 'tipo_entidade': _tipo_entidade, 'estatuto_social_url': _estatuto_social_url, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'perfil': _perfil,
    'email': _email,
    'telefone': _telefone,
    'endereco_texto': _endereco_texto,
    'latitude': _latitude,
    'longitude': _longitude,
    'nome': _nome,
    'cpf': _cpf,
    'escopo_operario': _escopo_operario,
    'nivel_operario': _nivel_operario,
    'nivel_de_experiencia_sistema': _nivel_de_experiencia_sistema,
    'quantidade_servicos_realizados': _quantidade_servicos_realizados,
    'raio_atendimento_km': _raio_atendimento_km,
    'portfolio_url': _portfolio_url,
    'experiencias_anteriores': _experiencias_anteriores,
    'nome_instituicao': _nome_instituicao,
    'cnpj': _cnpj,
    'tipo_entidade': _tipo_entidade,
    'estatuto_social_url': _estatuto_social_url,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PERFIL = amplify_core.QueryField(fieldName: "perfil");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final TELEFONE = amplify_core.QueryField(fieldName: "telefone");
  static final ENDERECO_TEXTO = amplify_core.QueryField(fieldName: "endereco_texto");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final NOME = amplify_core.QueryField(fieldName: "nome");
  static final CPF = amplify_core.QueryField(fieldName: "cpf");
  static final ESCOPO_OPERARIO = amplify_core.QueryField(fieldName: "escopo_operario");
  static final NIVEL_OPERARIO = amplify_core.QueryField(fieldName: "nivel_operario");
  static final NIVEL_DE_EXPERIENCIA_SISTEMA = amplify_core.QueryField(fieldName: "nivel_de_experiencia_sistema");
  static final QUANTIDADE_SERVICOS_REALIZADOS = amplify_core.QueryField(fieldName: "quantidade_servicos_realizados");
  static final RAIO_ATENDIMENTO_KM = amplify_core.QueryField(fieldName: "raio_atendimento_km");
  static final PORTFOLIO_URL = amplify_core.QueryField(fieldName: "portfolio_url");
  static final EXPERIENCIAS_ANTERIORES = amplify_core.QueryField(fieldName: "experiencias_anteriores");
  static final NOME_INSTITUICAO = amplify_core.QueryField(fieldName: "nome_instituicao");
  static final CNPJ = amplify_core.QueryField(fieldName: "cnpj");
  static final TIPO_ENTIDADE = amplify_core.QueryField(fieldName: "tipo_entidade");
  static final ESTATUTO_SOCIAL_URL = amplify_core.QueryField(fieldName: "estatuto_social_url");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        provider: amplify_core.AuthRuleProvider.APIKEY,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PERFIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.TELEFONE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.ENDERECO_TEXTO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.NOME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CPF,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.ESCOPO_OPERARIO,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.NIVEL_OPERARIO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.NIVEL_DE_EXPERIENCIA_SISTEMA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.QUANTIDADE_SERVICOS_REALIZADOS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.RAIO_ATENDIMENTO_KM,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PORTFOLIO_URL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EXPERIENCIAS_ANTERIORES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.NOME_INSTITUICAO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CNPJ,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.TIPO_ENTIDADE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.ESTATUTO_SOCIAL_URL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}