class NotificationModel {
  String id;
  String title;
  String text;
  String created_at;

  NotificationModel({
    this.id,
    this.title,
    this.text,
    this.created_at,
  });

  factory NotificationModel.fromMap(Map notification) {
    return NotificationModel(
      id: notification['id'].toString(),
      title: notification['title'].toString(),
      text: notification['text'].toString(),
      created_at: notification['created_at'].toString(),
    );
  }
}
