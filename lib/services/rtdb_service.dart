import 'package:firebase_database/firebase_database.dart';
import 'package:myplans/models/plans_send_model.dart';

class RTDBService {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addData(Post post) async {
    _database.child('posts').push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getData(String id) async {
    List<Post> items = [];
    Query query =
        _database.ref.child('posts').orderByChild('userId').equalTo(id);
    DatabaseEvent snapshot = await query.once();
    for (DataSnapshot item in snapshot.snapshot.children) {
      items.add(Post.fromJson(item.value as Map));
    }
    return items;
  }
}
