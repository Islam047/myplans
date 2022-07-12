class Post {
  late String userId;
  late String fullName;
  late String content;
  late String dueDate;
  String? imgUrl;

  Post(this.userId, this.fullName, this.content,this.dueDate, this.imgUrl);

  Post.fromJson(Map<dynamic, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    content = json['content'];
    dueDate = json['dueDate'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'content': content,
        'dueDate': dueDate,
        'imgUrl': imgUrl,
      };
}
