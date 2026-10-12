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


/** This is an auto generated class representing the Donation type in your schema. */
class Donation extends amplify_core.Model {
  static const classType = const _DonationModelType();
  final String id;
  final String? _instituicao_id;
  final double? _valor_doado;
  final amplify_core.TemporalDateTime? _data_doacao;
  final String? _codigo_pix_gerado;
  final String? _status_pagamento;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DonationModelIdentifier get modelIdentifier {
      return DonationModelIdentifier(
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
  
  double? get valor_doado {
    return _valor_doado;
  }
  
  amplify_core.TemporalDateTime? get data_doacao {
    return _data_doacao;
  }
  
  String? get codigo_pix_gerado {
    return _codigo_pix_gerado;
  }
  
  String? get status_pagamento {
    return _status_pagamento;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Donation._internal({required this.id, required instituicao_id, valor_doado, data_doacao, codigo_pix_gerado, status_pagamento, createdAt, updatedAt}): _instituicao_id = instituicao_id, _valor_doado = valor_doado, _data_doacao = data_doacao, _codigo_pix_gerado = codigo_pix_gerado, _status_pagamento = status_pagamento, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Donation({String? id, required String instituicao_id, double? valor_doado, amplify_core.TemporalDateTime? data_doacao, String? codigo_pix_gerado, String? status_pagamento}) {
    return Donation._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      instituicao_id: instituicao_id,
      valor_doado: valor_doado,
      data_doacao: data_doacao,
      codigo_pix_gerado: codigo_pix_gerado,
      status_pagamento: status_pagamento);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Donation &&
      id == other.id &&
      _instituicao_id == other._instituicao_id &&
      _valor_doado == other._valor_doado &&
      _data_doacao == other._data_doacao &&
      _codigo_pix_gerado == other._codigo_pix_gerado &&
      _status_pagamento == other._status_pagamento;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Donation {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("instituicao_id=" + "$_instituicao_id" + ", ");
    buffer.write("valor_doado=" + (_valor_doado != null ? _valor_doado!.toString() : "null") + ", ");
    buffer.write("data_doacao=" + (_data_doacao != null ? _data_doacao!.format() : "null") + ", ");
    buffer.write("codigo_pix_gerado=" + "$_codigo_pix_gerado" + ", ");
    buffer.write("status_pagamento=" + "$_status_pagamento" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Donation copyWith({String? instituicao_id, double? valor_doado, amplify_core.TemporalDateTime? data_doacao, String? codigo_pix_gerado, String? status_pagamento}) {
    return Donation._internal(
      id: id,
      instituicao_id: instituicao_id ?? this.instituicao_id,
      valor_doado: valor_doado ?? this.valor_doado,
      data_doacao: data_doacao ?? this.data_doacao,
      codigo_pix_gerado: codigo_pix_gerado ?? this.codigo_pix_gerado,
      status_pagamento: status_pagamento ?? this.status_pagamento);
  }
  
  Donation copyWithModelFieldValues({
    ModelFieldValue<String>? instituicao_id,
    ModelFieldValue<double?>? valor_doado,
    ModelFieldValue<amplify_core.TemporalDateTime?>? data_doacao,
    ModelFieldValue<String?>? codigo_pix_gerado,
    ModelFieldValue<String?>? status_pagamento
  }) {
    return Donation._internal(
      id: id,
      instituicao_id: instituicao_id == null ? this.instituicao_id : instituicao_id.value,
      valor_doado: valor_doado == null ? this.valor_doado : valor_doado.value,
      data_doacao: data_doacao == null ? this.data_doacao : data_doacao.value,
      codigo_pix_gerado: codigo_pix_gerado == null ? this.codigo_pix_gerado : codigo_pix_gerado.value,
      status_pagamento: status_pagamento == null ? this.status_pagamento : status_pagamento.value
    );
  }
  
  Donation.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _instituicao_id = json['instituicao_id'],
      _valor_doado = (json['valor_doado'] as num?)?.toDouble(),
      _data_doacao = json['data_doacao'] != null ? amplify_core.TemporalDateTime.fromString(json['data_doacao']) : null,
      _codigo_pix_gerado = json['codigo_pix_gerado'],
      _status_pagamento = json['status_pagamento'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'instituicao_id': _instituicao_id, 'valor_doado': _valor_doado, 'data_doacao': _data_doacao?.format(), 'codigo_pix_gerado': _codigo_pix_gerado, 'status_pagamento': _status_pagamento, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'instituicao_id': _instituicao_id,
    'valor_doado': _valor_doado,
    'data_doacao': _data_doacao,
    'codigo_pix_gerado': _codigo_pix_gerado,
    'status_pagamento': _status_pagamento,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DonationModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DonationModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final INSTITUICAO_ID = amplify_core.QueryField(fieldName: "instituicao_id");
  static final VALOR_DOADO = amplify_core.QueryField(fieldName: "valor_doado");
  static final DATA_DOACAO = amplify_core.QueryField(fieldName: "data_doacao");
  static final CODIGO_PIX_GERADO = amplify_core.QueryField(fieldName: "codigo_pix_gerado");
  static final STATUS_PAGAMENTO = amplify_core.QueryField(fieldName: "status_pagamento");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Donation";
    modelSchemaDefinition.pluralName = "Donations";
    
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
      key: Donation.INSTITUICAO_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Donation.VALOR_DOADO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Donation.DATA_DOACAO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Donation.CODIGO_PIX_GERADO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Donation.STATUS_PAGAMENTO,
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

class _DonationModelType extends amplify_core.ModelType<Donation> {
  const _DonationModelType();
  
  @override
  Donation fromJson(Map<String, dynamic> jsonData) {
    return Donation.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Donation';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Donation] in your schema.
 */
class DonationModelIdentifier implements amplify_core.ModelIdentifier<Donation> {
  final String id;

  /** Create an instance of DonationModelIdentifier using [id] the primary key. */
  const DonationModelIdentifier({
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
  String toString() => 'DonationModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DonationModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}