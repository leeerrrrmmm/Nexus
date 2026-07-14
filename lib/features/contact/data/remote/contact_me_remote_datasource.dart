import 'package:dio/dio.dart';
import 'package:flod/dio.dart';
import 'package:flod/flod.dart';
import 'package:flod/guard.dart';
import 'package:portfolio/core/config/env.dart';
import 'package:portfolio/features/contact/data/model/contact_me_model.dart';
import 'package:portfolio/features/contact/data/validation/contact_me_schema.dart';

abstract class ContactMeRemoteDataSource {
  Future<void> sendForm(ContactMeModel model);
}

class ContactMeRemoteDataSourceImpl implements ContactMeRemoteDataSource {
  final Dio dio;

  static final JsonGuard _guard = const JsonGuard(
    options: JsonGuardOptions(
      maxDepth: 8,
      maxKeys: 50,
      maxStringLength: 5000,
      maxArrayLength: 50,
      blockPrototypeKeys: true,
    ),
  );

  ContactMeRemoteDataSourceImpl({required this.dio}) {
    dio.interceptors.add(
      FlodValidateInterceptor(
        schema: contactMeResponseSchema,
        guard: _guard,
        extractData: (r) => r.data as Map,
      ),
    );
  }

  @override
  Future<void> sendForm(ContactMeModel model) async {
    // 1. Валидация входных данных
    final validation = contactMeSchema.safeParse(model.toJson());

    if (validation is FlodFailure) {
      throw Exception('Validation error: ${validation.toReadable()}');
    }

    final validatedData =
        (validation as FlodSuccess).data as Map<String, dynamic>;

    // 2. Подготовка payload + антиспам SplitForms
    final payload = <String, dynamic>{
      ...validatedData,
      'access_key': Env.contactFormAccessKey,
      'subject': validatedData['subject'] ?? 'New contact form submission',

      // === Антиспам защиты ===
      'botcheck': '', // Honeypot (главное!)
      '_timestamp': DateTime.now().millisecondsSinceEpoch
          .toString(), // Time check
      // Можно добавить другие поля, если нужно
    };

    try {
      final response = await dio.post(
        'https://splitforms.com/api/submit',
        data: payload,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final Map<String, dynamic> respData =
          response.data as Map<String, dynamic>;
      final bool success = respData['success'] == true;

      if (!success) {
        throw Exception(respData['message'] ?? 'Failed to send form');
      }
    } on DioException catch (e) {
      if (e.error is FlodFailure) {
        final error = e.error as FlodFailure;
        throw Exception('Response validation error: ${error.toReadable()}');
      }

      if (e.response != null) {
        final data = e.response?.data;
        throw Exception(
          'Server error ${e.response?.statusCode}: ${data?['message'] ?? data}',
        );
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
