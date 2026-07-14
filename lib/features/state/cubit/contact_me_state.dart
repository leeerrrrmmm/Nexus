part of 'contact_me_cubit.dart';

sealed class ContactMeState {
  const ContactMeState();
}

class ContactMeInitial extends ContactMeState {
  const ContactMeInitial();
}

class ContactMeLoading extends ContactMeState {
  const ContactMeLoading();
}

class ContactMeSuccess extends ContactMeState {
  const ContactMeSuccess();
}

class ContactMeFailure extends ContactMeState {
  final String message;
  const ContactMeFailure(this.message);
}
