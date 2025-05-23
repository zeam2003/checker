import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  dio.options.baseUrl = 'https://demo.ecosistemasglobal.com';
  return dio;
});