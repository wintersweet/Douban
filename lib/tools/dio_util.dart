import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'MockInterceptor.dart';
import 'base_resp.dart';

/// 请求方法.
class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

/// Http配置.
class HttpConfig {
  /// constructor.
  HttpConfig({
    this.enableLogging,
    this.mockRepo,
    this.code,
    this.msg,
    this.data,
    this.options,
    this.pem,
    this.pKCSPath,
    this.pKCSPwd,
  });

  /// Enable logging
  bool enableLogging;

  /// Mock repo
  String mockRepo;

  /// BaseResp [int code]字段 key, 默认：code.
  String code;

  /// BaseResp [String msg]字段 key, message.
  String msg;

  /// BaseResp [T data]字段 key, 默认：data.
  String data;

  /// Options.
  BaseOptions options;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PEM证书内容.
  String pem;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书路径.
  String pKCSPath;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书密码.
  String pKCSPwd;
}

/// 单例 DioUtil.
/// debug模式下可以打印请求日志. DioUtil.openDebug().
/// dio详细使用请查看dio官网(https://github.com/flutterchina/dio).
class DioUtil {
  static final DioUtil _singleton = DioUtil._init();
  static Dio _dio;

  /// BaseResp [int code]字段 key, 默认：errorCode.
  String _codeKey = "code";

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  String _msgKey = "message";

  /// BaseResp [T data]字段 key, 默认：data.
  String _dataKey = "result";

  /// Options.
  BaseOptions _options = getDefOptions();

  /// PEM证书内容.
  String _pem;

  /// PKCS12 证书路径.
  String _pKCSPath;

  /// PKCS12 证书密码.
  String _pKCSPwd;

  factory DioUtil() => _singleton;

  DioUtil._init() {
    _dio = Dio(_options);
  }

  void setCookie(String cookie) {
    Map<String, dynamic> _headers = {};
    _headers["Cookie"] = cookie;
    _dio.options.headers.addAll(_headers);
  }

  /// set Config.
  void setConfig(HttpConfig config) {
    _codeKey = config.code ?? _codeKey;
    _msgKey = config.msg ?? _msgKey;
    _dataKey = config.data ?? _dataKey;
    _mergeOption(config.options);
    _pem = config.pem ?? _pem;
    if (_dio != null) {
      _dio.options = _options;
      if (_pem != null) {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            if (cert.pem == _pem) {
              // 证书一致，则放行
              return true;
            }
            return false;
          };
        };
      }
      if (_pKCSPath != null) {
        (_dio.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient client) {
          SecurityContext sc = SecurityContext();
          //file为证书路径
          sc.setTrustedCertificates(_pKCSPath, password: _pKCSPwd);
          HttpClient httpClient = HttpClient(context: sc);
          return httpClient;
        };
      }

      if (config.enableLogging) {
        _dio.interceptors
            .add(LogInterceptor(requestBody: true, responseBody: true));
      }

      if (config.mockRepo != null) {
        _dio.interceptors.add(MockInterceptor(config.mockRepo));
      }
    }
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseResp<T> 返回 status code msg data .
  Future<BaseResp<T>> request<T>(String method, String path,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress}) async {
    Response response = await _dio.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    int _code;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _code = (response.data[_codeKey] is String)
              ? int.tryParse(response.data[_codeKey] as String)
              : response.data[_codeKey] as int;
          _msg = response.data[_msgKey] as String;
          _data = response.data[_dataKey] as T;
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _code = (_dataMap[_codeKey] is String)
              ? int.tryParse(_dataMap[_codeKey] as String)
              : _dataMap[_codeKey] as int;
          _msg = _dataMap[_msgKey] as String;
          _data = _dataMap[_dataKey] as T;
        }
        return BaseResp(_code, _msg, _data);
      } on Exception {
        return Future.error(DioError(
          response: response,
          type: DioErrorType.RESPONSE,
          error: "data parsing exception...",
        ));
      }
    }
    return Future.error(DioError(
      response: response,
      type: DioErrorType.RESPONSE,
      error: "statusCode: $response.statusCode, service error",
    ));
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseRespR<T> 返回 status code msg data  Response.
  Future<BaseRespR<T>> requestR<T>(String method, String path,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.request(path,
        data: data,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    int _code;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _code = (response.data[_codeKey] is String)
              ? int.tryParse(response.data[_codeKey] as String)
              : response.data[_codeKey] as int;
          _msg = response.data[_msgKey] as String;
          _data = response.data[_dataKey] as T;
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _code = (_dataMap[_codeKey] is String)
              ? int.tryParse(_dataMap[_codeKey] as String)
              : _dataMap[_codeKey] as int;
          _msg = _dataMap[_msgKey] as String;
          _data = _dataMap[_dataKey] as T;
        }
        return BaseRespR(_code, _msg, _data, response);
      } on Exception {
        return Future.error(DioError(
          response: response,
          type: DioErrorType.RESPONSE,
          error: "data parsing exception...",
        ));
      }
    }
    return Future.error(DioError(
      response: response,
      type: DioErrorType.RESPONSE,
      error: "statusCode: $response.statusCode, service error",
    ));
  }

  /// Download the file and save it in local. The default http method is "GET",you can custom it by [Options.method].
  /// [urlPath]: The file url.
  /// [savePath]: The path to save the downloading file later.
  /// [onProgress]: The callback to listen downloading progress.please refer to [OnDownloadProgress].
  Future<Response> download(
    String urlPath,
    savePath, {
    ProgressCallback onProgress,
    CancelToken cancelToken,
    data,
    Options options,
  }) {
    return _dio.download(urlPath, savePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
        data: data,
        options: options);
  }

  /// decode response data.
  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return Map();
    }
    return json.decode(response.data.toString()) as Map<String, dynamic>;
  }

  /// check Options.
  Options _checkOptions(String method, Options options) {
    if (options == null) {
      options = Options();
    }
    options.method = method;
    return options;
  }

  /// merge Option.
  void _mergeOption(BaseOptions opt) {
    _options.method = opt.method ?? _options.method;
    _options.headers = (Map.from(_options.headers))..addAll(opt.headers);
    _options.baseUrl = opt.baseUrl ?? _options.baseUrl;
    _options.connectTimeout = opt.connectTimeout ?? _options.connectTimeout;
    _options.receiveTimeout = opt.receiveTimeout ?? _options.receiveTimeout;
    _options.responseType = opt.responseType ?? _options.responseType;
//    _options.data = opt.data ?? _options.data;
    _options.extra = (Map.from(_options.extra))..addAll(opt.extra);
    _options.contentType = opt.contentType ?? _options.contentType;
    _options.validateStatus = opt.validateStatus ?? _options.validateStatus;
    _options.followRedirects = opt.followRedirects ?? _options.followRedirects;
  }

  /// get dio.
  Dio getDio() => _dio;

  /// create new dio.
  static Dio createNewDio([BaseOptions options]) {
    options = options ?? getDefOptions();
    Dio dio = Dio(options);
    return dio;
  }

  /// get Def Options.
  static BaseOptions getDefOptions() {
    BaseOptions options = BaseOptions();
    options.contentType = "application/x-www-form-urlencoded";
    options.connectTimeout = 1000 * 10;
    options.receiveTimeout = 1000 * 20;
    return options;
  }
}
