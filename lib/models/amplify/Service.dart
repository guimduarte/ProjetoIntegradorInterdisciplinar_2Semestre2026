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


/** This is an auto generated class representing the Service type in your schema. */
class Service extends amplify_core.Model {
  static const classType = const _ServiceModelType();
  final String id;
  final String? _instituicao_id;
  final String? _titulo;
  final String? _escopo_servico;
  final String? _complexidade;
  final String? _descricao;
  final String? _nivel_experiencia_exigido;
  final String? _endereco_texto;
  final double? _latitude;
  final double? _longitude;
  final String? _status_servico;
  final String? _instituicao_nome;
  final String? _instituicao_telefone;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ServiceModelIdentifier get modelIdentifier {
      return ServiceModelIdentifier(
        id: id
      );
  }
  
  String get instituicao_id {
    try {
      return _instituicao_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get titulo {
    try {
      return _titulo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get escopo_servico {
    return _escopo_servico;
  }
  
  String? get complexidade {
    return _complexidade;
  }
  
  String? get descricao {
    return _descricao;
  }
  
  String? get nivel_experiencia_exigido {
    return _nivel_experiencia_exigido;
  }
  
  String? get endereco_texto {
    return _endereco_texto;
  }
  
  double? get latitude {
    return _latitude;
  }
  
  double? get longitude {
    return _longitude;
  }
  
  String? get status_servico {
    return _status_servico;
  }
  
  String? get instituicao_nome {
    return _instituicao_nome;
  }
  
  String? get instituicao_telefone {
    return _instituicao_telefone;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Service._internal({required this.id, required instituicao_id, required titulo, escopo_servico, complexidade, descricao, nivel_experiencia_exigido, endereco_texto, latitude, longitude, status_servico, instituicao_nome, instituicao_telefone, createdAt, updatedAt}): _instituicao_id = instituicao_id, _titulo = titulo, _escopo_servico = escopo_servico, _complexidade = complexidade, _descricao = descricao, _nivel_experiencia_exigido = nivel_experiencia_exigido, _endereco_texto = endereco_texto, _latitude = latitude, _longitude = longitude, _status_servico = status_servico, _instituicao_nome = instituicao_nome, _instituicao_telefone = instituicao_telefone, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Service({String? id, required String instituicao_id, required String titulo, String? escopo_servico, String? complexidade, String? descricao, String? nivel_experiencia_exigido, String? endereco_texto, double? latitude, double? longitude, String? status_servico, String? instituicao_nome, String? instituicao_telefone}) {
    return Service._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      instituicao_id: instituicao_id,
      titulo: titulo,
      escopo_servico: escopo_servico,
      complexidade: complexidade,
      descricao: descricao,
      nivel_experiencia_exigido: nivel_experiencia_exigido,
      endereco_texto: endereco_texto,
      latitude: latitude,
      longitude: longitude,
      status_servico: status_servico,
      instituicao_nome: instituicao_nome,
      instituicao_telefone: instituicao_telefone);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Service &&
      id == other.id &&
      _instituicao_id == other._instituicao_id &&
      _titulo == other._titulo &&
      _escopo_servico == other._escopo_servico &&
      _complexidade == other._complexidade &&
      _descricao == other._descricao &&
      _nivel_experiencia_exigido == other._nivel_experiencia_exigido &&
      _endereco_texto == other._endereco_texto &&
      _latitude == other._latitude &&
      _longitude == other._longitude &&
      _status_servico == other._status_servico &&
      _instituicao_nome == other._instituicao_nome &&
      _instituicao_telefone == other._instituicao_telefone;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Service {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("instituicao_id=" + "$_instituicao_id" + ", ");
    buffer.write("titulo=" + "$_titulo" + ", ");
    buffer.write("escopo_servico=" + "$_escopo_servico" + ", ");
    buffer.write("complexidade=" + "$_complexidade" + ", ");
    buffer.write("descricao=" + "$_descricao" + ", ");
    buffer.write("nivel_experiencia_exigido=" + "$_nivel_experiencia_exigido" + ", ");
    buffer.write("endereco_texto=" + "$_endereco_texto" + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("status_servico=" + "$_status_servico" + ", ");
    buffer.write("instituicao_nome=" + "$_instituicao_nome" + ", ");
    buffer.write("instituicao_telefone=" + "$_instituicao_telefone" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Service copyWith({String? instituicao_id, String? titulo, String? escopo_servico, String? complexidade, String? descricao, String? nivel_experiencia_exigido, String? endereco_texto, double? latitude, double? longitude, String? status_servico, String? instituicao_nome, String? instituicao_telefone}) {
    return Service._internal(
      id: id,
      instituicao_id: instituicao_id ?? this.instituicao_id,
      titulo: titulo ?? this.titulo,
      escopo_servico: escopo_servico ?? this.escopo_servico,
      complexidade: complexidade ?? this.complexidade,
      descricao: descricao ?? this.descricao,
      nivel_experiencia_exigido: nivel_experiencia_exigido ?? this.nivel_experiencia_exigido,
      endereco_texto: endereco_texto ?? this.endereco_texto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status_servico: status_servico ?? this.status_servico,
      instituicao_nome: instituicao_nome ?? this.instituicao_nome,
      instituicao_telefone: instituicao_telefone ?? this.instituicao_telefone);
  }
  
  Service copyWithModelFieldValues({
    ModelFieldValue<String>? instituicao_id,
    ModelFieldValue<String>? titulo,
    ModelFieldValue<String?>? escopo_servico,
    ModelFieldValue<String?>? complexidade,
    ModelFieldValue<String?>? descricao,
    ModelFieldValue<String?>? nivel_experiencia_exigido,
    ModelFieldValue<String?>? endereco_texto,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<String?>? status_servico,
    ModelFieldValue<String?>? instituicao_nome,
    ModelFieldValue<String?>? instituicao_telefone
  }) {
    return Service._internal(
      id: id,
      instituicao_id: instituicao_id == null ? this.instituicao_id : instituicao_id.value,
      titulo: titulo == null ? this.titulo : titulo.value,
      escopo_servico: escopo_servico == null ? this.escopo_servico : escopo_servico.value,
      complexidade: complexidade == null ? this.complexidade : complexidade.value,
      descricao: descricao == null ? this.descricao : descricao.value,
      nivel_experiencia_exigido: nivel_experiencia_exigido == null ? this.nivel_experiencia_exigido : nivel_experiencia_exigido.value,
      endereco_texto: endereco_texto == null ? this.endereco_texto : endereco_texto.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      status_servico: status_servico == null ? this.status_servico : status_servico.value,
      instituicao_nome: instituicao_nome == null ? this.instituicao_nome : instituicao_nome.value,
      instituicao_telefone: instituicao_telefone == null ? this.instituicao_telefone : instituicao_telefone.value
    );
  }
  
  Service.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _instituicao_id = json['instituicao_id'],
      _titulo = json['titulo'],
      _escopo_servico = json['escopo_servico'],
      _complexidade = json['complexidade'],
      _descricao = json['descricao'],
      _nivel_experiencia_exigido = json['nivel_experiencia_exigido'],
      _endereco_texto = json['endereco_texto'],
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _status_servico = json['status_servico'],
      _instituicao_nome = json['instituicao_nome'],
      _instituicao_telefone = json['instituicao_telefone'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'instituicao_id': _instituicao_id, 'titulo': _titulo, 'escopo_servico': _escopo_servico, 'complexidade': _complexidade, 'descricao': _descricao, 'nivel_experiencia_exigido': _nivel_experiencia_exigido, 'endereco_texto': _endereco_texto, 'latitude': _latitude, 'longitude': _longitude, 'status_servico': _status_servico, 'instituicao_nome': _instituicao_nome, 'instituicao_telefone': _instituicao_telefone, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'instituicao_id': _instituicao_id,
    'titulo': _titulo,
    'escopo_servico': _escopo_servico,
    'complexidade': _complexidade,
    'descricao': _descricao,
    'nivel_experiencia_exigido': _nivel_experiencia_exigido,
    'endereco_texto': _endereco_texto,
    'latitude': _latitude,
    'longitude': _longitude,
    'status_servico': _status_servico,
    'instituicao_nome': _instituicao_nome,
    'instituicao_telefone': _instituicao_telefone,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ServiceModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ServiceModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final INSTITUICAO_ID = amplify_core.QueryField(fieldName: "instituicao_id");
  static final TITULO = amplify_core.QueryField(fieldName: "titulo");
  static final ESCOPO_SERVICO = amplify_core.QueryField(fieldName: "escopo_servico");
  static final COMPLEXIDADE = amplify_core.QueryField(fieldName: "complexidade");
  static final DESCRICAO = amplify_core.QueryField(fieldName: "descricao");
  static final NIVEL_EXPERIENCIA_EXIGIDO = amplify_core.QueryField(fieldName: "nivel_experiencia_exigido");
  static final ENDERECO_TEXTO = amplify_core.QueryField(fieldName: "endereco_texto");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final STATUS_SERVICO = amplify_core.QueryField(fieldName: "status_servico");
  static final INSTITUICAO_NOME = amplify_core.QueryField(fieldName: "instituicao_nome");
  static final INSTITUICAO_TELEFONE = amplify_core.QueryField(fieldName: "instituicao_telefone");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Service";
    modelSchemaDefinition.pluralName = "Services";
    
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
      key: Service.INSTITUICAO_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.TITULO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.ESCOPO_SERVICO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.COMPLEXIDADE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.DESCRICAO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.NIVEL_EXPERIENCIA_EXIGIDO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.ENDERECO_TEXTO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.STATUS_SERVICO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.INSTITUICAO_NOME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Service.INSTITUICAO_TELEFONE,
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

class _ServiceModelType extends amplify_core.ModelType<Service> {
  const _ServiceModelType();
  
  @override
  Service fromJson(Map<String, dynamic> jsonData) {
    return Service.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Service';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Service] in your schema.
 */
class ServiceModelIdentifier implements amplify_core.ModelIdentifier<Service> {
  final String id;

  /** Create an instance of ServiceModelIdentifier using [id] the primary key. */
  const ServiceModelIdentifier({
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
  String toString() => 'ServiceModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ServiceModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}