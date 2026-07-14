import 'package:portfolio/features/contact/data/model/contact_me_model.dart';
import 'package:portfolio/features/contact/data/remote/contact_me_remote_datasource.dart';
import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';
import 'package:portfolio/features/contact/domain/repo/contact_me_repo.dart';

class ContactMeRepoImpl implements ContactMeRepo {
  final ContactMeRemoteDataSource remoteDataSource;

  ContactMeRepoImpl({required this.remoteDataSource});

  @override
  Future<void> contactMe(ContactMeEntity entity) async {
    final model = ContactMeModel.fromEntity(entity);

    return await remoteDataSource.sendForm(model);
  }
}
