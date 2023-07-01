import 'package:encrypt/encrypt.dart' as encrypt;

const String ivb64 = "i6iQZWT5aMAc4f2d5vsBjA==";
encrypt.IV iv = encrypt.IV.fromBase64(ivb64);