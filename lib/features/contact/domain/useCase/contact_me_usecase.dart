import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';
import 'package:portfolio/features/contact/domain/repo/contact_me_repo.dart';

class ContactMeUseCase {
  final ContactMeRepo contactMeRepo;

  ContactMeUseCase({required this.contactMeRepo});

  Future<void> call(ContactMeEntity entity) async {
    return await contactMeRepo.contactMe(entity);
  }
}
