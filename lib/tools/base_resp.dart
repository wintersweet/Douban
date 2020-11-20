import 'package:dio/dio.dart';

/// <BaseResp<T> 返回 code msg data.
class BaseResp<T> {
  int code;
  String msg;
  T data;

  BaseResp(this.code, this.msg, this.data);

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write(",\"code\":$code");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}

/// <BaseRespR<T> 返回 code msg data Response.
class BaseRespR<T> {
  int code;
  String msg;
  T data;
  Response response;

  BaseRespR(this.code, this.msg, this.data, this.response);

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write(",\"code\":$code");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}