import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:crypto/src/digest_sink.dart' as sink;
import 'dart:convert' as convert;
import 'dart:async';

import '../globals.dart' as globals;

import 'user.dart';

class AuthService {
  String encrypt(String str) {
    sink.DigestSink ds = new sink.DigestSink();
    var s = crypto.sha1.startChunkedConversion(ds);
    s.add(convert.utf8.encode(str));
    s.close();
    return ds.value.toString();
  }

  String userToJson(User user) => "{\"username\": \"" + user.username + "\", \"password\": \"" + user.password + "\"}";

  Future<http.Response> login(User user) {
    return  http.post(globals.endpoint + globals.login, body: userToJson(user));
  }

  Future<http.Response> register(User user) {
    return  http.post(globals.endpoint + globals.register, body: userToJson(user));
  }
}
