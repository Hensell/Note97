class NoteModel {
  int? id;
  String? title;
  String? content;
  String? date;

  NoteModel(this.title, this.content, this.date);

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "content": content, "date": date};
  }

  NoteModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    content = map["content"];
    date = map["date"];
  }
}
