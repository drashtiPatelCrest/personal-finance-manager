import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/users_table.dart';

part 'auth_dao.g.dart';

@DriftAccessor(tables: [Users])
class AuthDao extends DatabaseAccessor<AppDatabase> with _$AuthDaoMixin {
  AuthDao(super.db);

  Future<User?> getUserByEmail(String email) {
    return (select(users)..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();
  }

  Future<User?> getUserById(int id) {
    return (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<bool> updatePassword({
    required int userId,
    required String passwordHash,
    required String salt,
  }) async {
    final updated = await (update(users)..where((tbl) => tbl.id.equals(userId)))
        .write(
      UsersCompanion(
        passwordHash: Value(passwordHash),
        salt: Value(salt),
      ),
    );
    return updated > 0;
  }

  Future<bool> verifySecurityAnswer({
    required int userId,
    required String securityAnswerHash,
  }) async {
    final user = await getUserById(userId);
    return user?.securityAnswerHash == securityAnswerHash;
  }

  Future<int> countUsers() async {
    final countExp = users.id.count();
    final query = selectOnly(users)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }
}
