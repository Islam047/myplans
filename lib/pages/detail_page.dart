import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:myplans/models/plans_send_model.dart';
import 'package:myplans/services/prefs_service.dart';
import 'package:myplans/services/rtdb_service.dart';
import 'package:myplans/services/store_service.dart';

class DetailPage extends StatefulWidget {
  static const String id = '/detail_page';

  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? _image;
  final _picker = ImagePicker();
  bool isLoading = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  void _addPost() {
    String fullName = fullNameController.text.toString().trim();
    String content = contentController.text.toString().trim();
    String dueDate = dueDateController.text.toString().trim();
    if (fullName.isEmpty || content.isEmpty || dueDate.isEmpty) return;
    if (_image == null) {
      _apiAddPost(fullName, content, dueDate, null);
    } else {
      _apiUploadImage(fullName, content, dueDate);
    }
  }

  void _apiUploadImage(String fullName, String content, String dueDate) {
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!).then((imgUrl) => {
          _apiAddPost(fullName, content, dueDate, imgUrl),
        });
  }

  void _apiAddPost(
      String fullName, String content, String dueDate, String? imgUrl) async {
    var userId = await Prefs.loadUserId();
    RTDBService.addData(Post(userId!, fullName, content, dueDate, imgUrl))
        .then((value) {
      _respAddPost();
    });
  }

  void _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, {'data': 'done'});
  }

  void _getImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
        } else {
          print('No image has been selected');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Add post',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/img.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: 'Content',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: dueDateController,
                    decoration: const InputDecoration(
                      hintText: 'DueDate',
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: _addPost,
                      color: Colors.deepOrange,
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
