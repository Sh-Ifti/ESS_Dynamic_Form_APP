class FormModel {
  final int id;
  final String formName;
  final List<SectionModel> sections;

  FormModel({required this.id, required this.formName, required this.sections});

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        id: json['id'],
        formName: json['formName'],
        sections: (json['sections'] as List)
            .map((e) => SectionModel.fromJson(e))
            .toList(),
      );
}

class SectionModel {
  final String name;
  final String key;
  final List<FieldModel> fields;

  SectionModel({required this.name, required this.key, required this.fields});

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        name: json['name'],
        key: json['key'],
        fields: (json['fields'] as List)
            .map((e) => FieldModel.fromJson(e))
            .toList(),
      );
}

class FieldModel {
  final int id;
  final String key;
  final Map<String, dynamic> properties;

  FieldModel({required this.id, required this.key, required this.properties});

  factory FieldModel.fromJson(Map<String, dynamic> json) => FieldModel(
        id: json['id'],
        key: json['key'],
        properties: Map<String, dynamic>.from(json['properties']),
      );
}
