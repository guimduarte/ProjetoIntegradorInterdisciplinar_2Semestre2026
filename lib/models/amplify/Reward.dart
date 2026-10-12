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


/** This is an auto generated class representing the Reward type in your schema. */
class Reward extends amplify_core.Model {
  static const classType = const _RewardModelType();
  final String id;
  final String? _operario_id;
  final double? _saldo_pontos_atual;
  final String? _historico_ganhos_json;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RewardModelIdentifier get modelIdentifier {
      return RewardModelIdentifier(
        id: id
      );
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
  
  double? get saldo_pontos_atual {
    return _saldo_pontos_atual;
  }
  
  String? get historico_ganhos_json {
    return _historico_ganhos_json;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Reward._internal({required this.id, required operario_id, saldo_pontos_atual, historico_ganhos_json, createdAt, updatedAt}): _operario_id = operario_id, _saldo_pontos_atual = saldo_pontos_atual, _historico_ganhos_json = historico_ganhos_json, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Reward({String? id, required String operario_id, double? saldo_pontos_atual, String? historico_ganhos_json}) {
    return Reward._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      operario_id: operario_id,
      saldo_pontos_atual: saldo_pontos_atual,
      historico_ganhos_json: historico_ganhos_json);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Reward &&
      id == other.id &&
      _operario_id == other._operario_id &&
      _saldo_pontos_atual == other._saldo_pontos_atual &&
      _historico_ganhos_json == other._historico_ganhos_json;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Reward {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("operario_id=" + "$_operario_id" + ", ");
    buffer.write("saldo_pontos_atual=" + (_saldo_pontos_atual != null ? _saldo_pontos_atual!.toString() : "null") + ", ");
    buffer.write("historico_ganhos_json=" + "$_historico_ganhos_json" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Reward copyWith({String? operario_id, double? saldo_pontos_atual, String? historico_ganhos_json}) {
    return Reward._internal(
      id: id,
      operario_id: operario_id ?? this.operario_id,
      saldo_pontos_atual: saldo_pontos_atual ?? this.saldo_pontos_atual,
      historico_ganhos_json: historico_ganhos_json ?? this.historico_ganhos_json);
  }
  
  Reward copyWithModelFieldValues({
    ModelFieldValue<String>? operario_id,
    ModelFieldValue<double?>? saldo_pontos_atual,
    ModelFieldValue<String?>? historico_ganhos_json
  }) {
    return Reward._internal(
      id: id,
      operario_id: operario_id == null ? this.operario_id : operario_id.value,
      saldo_pontos_atual: saldo_pontos_atual == null ? this.saldo_pontos_atual : saldo_pontos_atual.value,
      historico_ganhos_json: historico_ganhos_json == null ? this.historico_ganhos_json : historico_ganhos_json.value
    );
  }
  
  Reward.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _operario_id = json['operario_id'],
      _saldo_pontos_atual = (json['saldo_pontos_atual'] as num?)?.toDouble(),
      _historico_ganhos_json = json['historico_ganhos_json'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'operario_id': _operario_id, 'saldo_pontos_atual': _saldo_pontos_atual, 'historico_ganhos_json': _historico_ganhos_json, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'operario_id': _operario_id,
    'saldo_pontos_atual': _saldo_pontos_atual,
    'historico_ganhos_json': _historico_ganhos_json,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RewardModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RewardModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OPERARIO_ID = amplify_core.QueryField(fieldName: "operario_id");
  static final SALDO_PONTOS_ATUAL = amplify_core.QueryField(fieldName: "saldo_pontos_atual");
  static final HISTORICO_GANHOS_JSON = amplify_core.QueryField(fieldName: "historico_ganhos_json");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Reward";
    modelSchemaDefinition.pluralName = "Rewards";
    
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
      key: Reward.OPERARIO_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Reward.SALDO_PONTOS_ATUAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Reward.HISTORICO_GANHOS_JSON,
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

class _RewardModelType extends amplify_core.ModelType<Reward> {
  const _RewardModelType();
  
  @override
  Reward fromJson(Map<String, dynamic> jsonData) {
    return Reward.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Reward';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Reward] in your schema.
 */
class RewardModelIdentifier implements amplify_core.ModelIdentifier<Reward> {
  final String id;

  /** Create an instance of RewardModelIdentifier using [id] the primary key. */
  const RewardModelIdentifier({
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
  String toString() => 'RewardModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RewardModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}