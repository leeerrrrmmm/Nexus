import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';

class ContactMeModel extends ContactMeEntity {
  ContactMeModel({
    required super.email,
    required super.name,
    required super.message,
  });

  factory ContactMeModel.fromEntity(ContactMeEntity entity) {
    return ContactMeModel(
      email: entity.email,
      name: entity.name,
      message: entity.message,
    );
  }

  factory ContactMeModel.fromJson(Map<String, dynamic> json) {
    return ContactMeModel(
      email: json['email'] as String,
      name: json['name'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'message': message,
  };
}
