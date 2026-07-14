import 'package:flod/flod.dart';

/// Схема исходящих данных (то, что вводит пользователь)
final contactMeSchema = Flod.object({
  'name': Flod.string().trim().min(2).max(80),
  'email': Flod.string().trim().toLowerCase().email(),
  // 'subject': Flod.string().trim().min(3).max(150).optional(),
  'message': Flod.string().trim().min(10).max(2000),
});

/// Схема ответа сервера (для FlodValidateInterceptor)
final contactMeResponseSchema = Flod.object({
  'success': Flod.boolean(),
  'message': Flod.string().optional(),
}).passthrough();
