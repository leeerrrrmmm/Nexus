import 'package:bloc/bloc.dart';
import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';
import 'package:portfolio/features/contact/domain/useCase/contact_me_usecase.dart';

part 'contact_me_state.dart';

class ContactMeCubit extends Cubit<ContactMeState> {
  final ContactMeUseCase contactMeUseCase;

  ContactMeCubit({required this.contactMeUseCase})
    : super(const ContactMeInitial());

  Future<void> submit(ContactMeEntity entity) async {
    emit(const ContactMeLoading());
    try {
      await contactMeUseCase(entity);
      emit(const ContactMeSuccess());
    } catch (e) {
      emit(ContactMeFailure(e.toString()));
    }
  }

  void reset() => emit(const ContactMeInitial());
}
