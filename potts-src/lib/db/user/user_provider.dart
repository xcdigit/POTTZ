import '/model/login.dart';
import '/db/sql_provider.dart';

class UserDbProvider extends BaseDbProvider<Login> {
  final String name = 'userInfo';

  UserDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  Login fromJson(record) {
    return Login.fromJson(record);
  }

  @override
  toJson(Login model) {
    return model.toJson();
  }

  Future<Login?> getUserData(Login? user) async {
    if (user?.id == null) {
      return null;
    }
    return user;
  }
}
