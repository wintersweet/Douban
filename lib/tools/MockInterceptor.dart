import 'package:dio/dio.dart';

/// 使用json placeholder mock 数据
/// path中带有参数的暂未处理，可使用query参数
class MockInterceptor extends Interceptor {
  final String repo;

  MockInterceptor(this.repo);

  @override
  Future onRequest(RequestOptions options) async {
    options.baseUrl = 'https://my-json-server.typicode.com/$repo';
    String oldPath = options.path;
    String newPath = oldPath
        .split('/')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : '')
        .join();
    options.path = '/$newPath';
    return options;
  }
}