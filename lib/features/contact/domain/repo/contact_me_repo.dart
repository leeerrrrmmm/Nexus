import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';

abstract class ContactMeRepo {
  Future<void> contactMe(ContactMeEntity entity);
}
