import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/services/password_hasher.dart';

void main() {
  late PasswordHasher passwordHasher;

  setUp(() {
    passwordHasher = PasswordHasher();
  });

  test('hashPassword produces consistent output for same salt', () async {
    const salt = '0123456789abcdef0123456789abcdef';
    const password = 'password123';

    final hash1 = await passwordHasher.hashPassword(password: password, salt: salt);
    final hash2 = await passwordHasher.hashPassword(password: password, salt: salt);

    expect(hash1, hash2);
  });

  test('verifyPassword returns true for matching password', () async {
    const password = 'securePassword1';
    final salt = await passwordHasher.generateSalt();
    final hash = await passwordHasher.hashPassword(password: password, salt: salt);

    expect(
      await passwordHasher.verifyPassword(
        password: password,
        salt: salt,
        expectedHash: hash,
      ),
      isTrue,
    );
  });

  test('verifyPassword returns false for incorrect password', () async {
    const password = 'securePassword1';
    final salt = await passwordHasher.generateSalt();
    final hash = await passwordHasher.hashPassword(password: password, salt: salt);

    expect(
      await passwordHasher.verifyPassword(
        password: 'wrongPassword',
        salt: salt,
        expectedHash: hash,
      ),
      isFalse,
    );
  });

  test('generateSalt produces unique values', () async {
    final salt1 = await passwordHasher.generateSalt();
    final salt2 = await passwordHasher.generateSalt();

    expect(salt1, isNot(equals(salt2)));
  });
}
