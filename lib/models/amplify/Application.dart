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


/** This is an auto generated class representing the Application type in your schema. */
class Application extends amplify_core.Model {
  static const classType = const _ApplicationModelType();
  final String id;
  final String? _service_id;
  final String? _operario_id;
  final String? _status_candidatura;
  final amplify_core.TemporalDateTime? _data_solicitacao;
  final String? _resumo_operario_nome;
  final List<String>? _resumo_operario_escopo;
  final String? _resumo_operario_nivel;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ApplicationModelIdentifier get modelIdentifier {
      return ApplicationModelIdentifier(
        id: id
      );
  }
  
  String get service_id {
    try {
      return _service_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get operario_id {
    try {
      return _operario_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get status_candidatura {
    return _status_candidatura;
  }
  
  amplify_core.TemporalDateTime? get data_solicitacao {
    return _data_solicitacao;
  }
  
  String? get resumo_operario_nome {
    return _resumo_operario_nome;
  }
  
  List<String>? get resumo_operario_escopo {
    return _resumo_operario_escopo;
  }
  
  String? get resumo_operario_nivel {
    return _resumo_operario_nivel;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Application._internal({required this.id, required service_id, required operario_id, status_candidatura, data_solicitacao, resumo_operario_nome, resumo_operario_escopo, resumo_operario_nivel, createdAt, updatedAt}): _service_id = service_id, _operario_id = operario_id, _status_candidatura = status_candidatura, _data_solicitacao = data_solicitacao, _resumo_operario_nome = resumo_operario_nome, _resumo_operario_escopo = resumo_operario_escopo, _resumo_operario_nivel = resumo_operario_nivel, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Application({String? id, required String service_id, required String operario_id, String? status_candidatura, amplify_core.TemporalDateTime? data_solicitacao, String? resumo_operario_nome, List<String>? resumo_operario_escopo, String? resumo_operario_nivel}) {
    return Application._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      service_id: service_id,
      operario_id: operario_id,
      status_candidatura: status_candidatura,
      data_solicitacao: data_solicitacao,
      resumo_operario_nome: resumo_operario_nome,
      resumo_operario_escopo: resumo_operario_escopo != null ? List<String>.unmodifiable(resumo_operario_escopo) : resumo_operario_escopo,
      resumo_operario_nivel: resumo_operario_nivel);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Application &&
      id == other.id &&
      _service_id == other._service_id &&
      _operario_id == other._operario_id &&
      _status_candidatura == other._status_candidatura &&
      _data_solicitacao == other._data_solicitacao &&
      _resumo_operario_nome == other._resumo_operario_nome &&
      DeepCollectionEquality().equals(_resumo_operario_escopo, other._resumo_operario_escopo) &&
      _resumo_operario_nivel == other._resumo_operario_nivel;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Application {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("service_id=" + "$_service_id" + ", ");
    buffer.write("operario_id=" + "$_operario_id" + ", ");
    buffer.write("status_candidatura=" + "$_status_candidatura" + ", ");
    buffer.write("data_solicitacao=" + (_data_solicitacao != null ? _data_solicitacao!.format() : "null") + ", ");
    buffer.write("resumo_operario_nome=" + "$_resumo_operario_nome" + ", ");
    buffer.write("resumo_operario_escopo=" + (_resumo_operario_escopo != null ? _resumo_operario_escopo!.toString() : "null") + ", ");
    buffer.write("resumo_operario_nivel=" + "$_resumo_operario_nivel" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Application copyWith({String? service_id, String? operario_id, String? status_candidatura, amplify_core.TemporalDateTime? data_solicitacao, String? resumo_operario_nome, List<String>? resumo_operario_escopo, String? resumo_operario_nivel}) {
    return Application._internal(
      id: id,
      service_id: service_id ?? this.service_id,
      operario_id: operario_id ?? this.operario_id,
      status_candidatura: status_candidatura ?? this.status_candidatura,
      data_solicitacao: data_solicitacao ?? this.data_solicitacao,
      resumo_operario_nome: resumo_operario_nome ?? this.resumo_operario_nome,
      resumo_operario_escopo: resumo_operario_escopo ?? this.resumo_operario_escopo,
      resumo_operario_nivel: resumo_operario_nivel ?? this.resumo_operario_nivel);
  }
  
  Application copyWithModelFieldValues({
    ModelFieldValue<String>? service_id,
    ModelFieldValue<String>? operario_id,
    ModelFieldValue<String?>? status_candidatura,
    ModelFieldValue<amplify_core.TemporalDateTime?>? data_solicitacao,
    ModelFieldValue<String?>? resumo_operario_nome,
    ModelFieldValue<List<String>?>? resumo_operario_escopo,
    ModelFieldValue<String?>? resumo_operario_nivel
  }) {
    return Application._internal(
      id: id,
      service_id: service_id == null ? this.service_id : service_id.value,
      operario_id: operario_id == null ? this.operario_id : operario_id.value,
      status_candidatura: status_candidatura == null ? this.status_candidatura : status_candidatura.value,
      data_solicitacao: data_solicitacao == null ? this.data_solicitacao : data_solicitacao.value,
      resumo_operario_nome: resumo_operario_nome == null ? this.resumo_operario_nome : resumo_operario_nome.value,
      resumo_operario_escopo: resumo_operario_escopo == null ? this.resumo_operario_escopo : resumo_operario_escopo.value,
      resumo_operario_nivel: resumo_operario_nivel == null ? this.resumo_operario_nivel : resumo_operario_nivel.value
    );
  }
  
  Application.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _service_id = json['service_id'],
      _operario_id = json['operario_id'],
      _status_candidatura = json['status_candidatura'],
      _data_solicitacao = json['data_solicitacao'] != null ? amplify_core.TemporalDateTime.fromString(json['data_solicitacao']) : null,
      _resumo_operario_nome = json['resumo_operario_nome'],
      _resumo_operario_escopo = json['resumo_operario_escopo']?.cast<String>(),
      _resumo_operario_nivel = json['resumo_operario_nivel'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'service_id': _service_id, 'operario_id': _operario_id, 'status_candidatura': _status_candidatura, 'data_solicitacao': _data_solicitacao?.format(), 'resumo_operario_nome': _resumo_operario_nome, 'resumo_operario_escopo': _resumo_operario_escopo, 'resumo_operario_nivel': _resumo_operario_nivel, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'service_id': _service_id,
    'operario_id': _operario_id,
    'status_candidatura': _status_candidatura,
    'data_solicitacao': _data_solicitacao,
    'resumo_operario_nome': _resumo_operario_nome,
    'resumo_operario_escopo': _resumo_operario_escopo,
    'resumo_operario_nivel': _resumo_operario_nivel,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ApplicationModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ApplicationModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SERVICE_ID = amplify_core.QueryField(fieldName: "service_id");
  static final OPERARIO_ID = amplify_core.QueryField(fieldName: "operario_id");
  static final STATUS_CANDIDATURA = amplify_core.QueryField(fieldName: "status_candidatura");
  static final DATA_SOLICITACAO = amplify_core.QueryField(fieldName: "data_solicitacao");
  static final RESUMO_OPERARIO_NOME = amplify_core.QueryField(fieldName: "resumo_operario_nome");
  static final RESUMO_OPERARIO_ESCOPO = amplify_core.QueryField(fieldName: "resumo_operario_escopo");
  static final RESUMO_OPERARIO_NIVEL = amplify_core.QueryField(fieldName: "resumo_operario_nivel");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Application";
    modelSchemaDefinition.pluralName = "Applications";
    
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
      key: Application.SERVICE_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Application.OPERARIO_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Application.STATUS_CANDIDATURA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Application.DATA_SOLICITACAO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Application.RESUMO_OPERARIO_NOME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Application.RESUMO_OPERARIO_ESCOPO,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Application.RESUMO_OPERARIO_NIVEL,
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

class _ApplicationModelType extends amplify_core.ModelType<Application> {
  const _ApplicationModelType();
  
  @override
  Application fromJson(Map<String, dynamic> jsonData) {
    return Application.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Application';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Application] in your schema.
 */
class ApplicationModelIdentifier implements amplify_core.ModelIdentifier<Application> {
  final String id;

  /** Create an instance of ApplicationModelIdentifier using [id] the primary key. */
  const ApplicationModelIdentifier({
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
  String toString() => 'ApplicationModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ApplicationModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}