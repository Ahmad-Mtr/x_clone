import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x_clone/constants/constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/core/providers.dart';
import 'package:x_clone/models/user_model.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  return UserAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({
    required Databases db,
  }) : _db = db;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? "Some Unexpected error occured", st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }
}
