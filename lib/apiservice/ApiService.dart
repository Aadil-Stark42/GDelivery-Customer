/*
import 'dart:convert';

import 'package:http/http.dart' as http;

 */

import 'package:dio/dio.dart';

import 'EndPoints.dart';

Dio GetApiInstance() {
  var dio = Dio();
  dio.options.baseUrl = BASE_URL;
  dio.options.contentType = Headers.formUrlEncodedContentType;
  return dio;
}

Dio GetApiInstanceWithHeaders(header) {
  var dio = Dio();
  dio.options.baseUrl = BASE_URL;
  dio.options.headers = header;
  return dio;
}
