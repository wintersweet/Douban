// GENERATED CODE - DO NOT MODIFY BY HAND

part of global;

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..user = json['user'] as String
    ..isLogin = json['isLogin'] as bool
    ..avatar = json['avatar'] as String;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'isLogin': instance.isLogin,
      'avatar': instance.avatar,
    };
