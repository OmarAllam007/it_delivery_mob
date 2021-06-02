class NotificationModel {
  String id;
  String title;
  String text;
  String created_at;
  String request_id;

  NotificationModel({
    this.id,
    this.title,
    this.text,
    this.created_at,
    this.request_id
  });

  factory NotificationModel.fromMap(Map notification) {
    return NotificationModel(
      id: notification['id'].toString(),
      title: notification['title'].toString(),
      text: notification['text'].toString(),
      created_at: notification['created_at'].toString(),
      request_id: notification['request_id'],
    );
  }
}
