import 'package:flutter/material.dart';
import 'package:myplans/models/plans_send_model.dart';
import 'package:myplans/pages/detail_page.dart';
import 'package:myplans/services/auth_service.dart';
import 'package:myplans/services/prefs_service.dart';
import 'package:myplans/services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiGetPost();
  }

  void _apiGetPost() async {
    setState((){
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getData(id!).then((post) => {
    _respPosts(post),
    });
  }

  void _respPosts(List<Post> item) {
    setState((){
      isLoading = false;
    });
    setState(() {
      items = item;
    });
  }

  void _openDetailPage() async {
    Map result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext content) {
          return const DetailPage();
        }));
    if (result != null && result.containsKey('data')) {
      _apiGetPost();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Home Page', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () {
            AuthService.signOutUser(context);
          }, icon: const Icon(Icons.exit_to_app,), color: Colors.white,)
        ],
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _itemOfList(items[index]);
          },),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget _itemOfList(Post post) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: post.imgUrl != null ? Image.network(
              post.imgUrl!, fit: BoxFit.fill,) : const Image(
              image: AssetImage('assets/images/img.png',), fit: BoxFit.fill,),

          ),
          const SizedBox(height: 5,),
          Text(post.fullName,
            style: const TextStyle(fontSize: 20, color: Colors.black),),
          const SizedBox(height: 10,),
          Text(post.content,
            style: const TextStyle(fontSize: 20, color: Colors.black),),
          const SizedBox(height: 10,),
          Text(post.dueDate,
            style: const TextStyle(fontSize: 20, color: Colors.black),),
        ],
      ),
    );
  }
}
