import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';

/// Hashes and verifies passwords using PBKDF2-HMAC-SHA256.
@lazySingleton
class PasswordHasher {
  static const int _saltLength = 16;

  final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  Future<String> generateSalt() async {
    final random = Random.secure();
    final bytes = List<int>.generate(
      _saltLength,
      (_) => random.nextInt(256),
    );
    return _encodeBytes(bytes);
  }

  Future<String> hashPassword({
    required String password,
    required String salt,
  }) async {
    final secretKey = await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: _decodeBytes(salt),
    );
    final hashBytes = await secretKey.extractBytes();
    return _encodeBytes(hashBytes);
  }

  Future<bool> verifyPassword({
    required String password,
    required String salt,
    required String expectedHash,
  }) async {
    final hash = await hashPassword(password: password, salt: salt);
    return hash == expectedHash;
  }

  String _encodeBytes(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  List<int> _decodeBytes(String encoded) {
    return List<int>.generate(
      encoded.length ~/ 2,
      (index) => int.parse(encoded.substring(index * 2, index * 2 + 2), radix: 16),
    );
  }
}
