class NotificationSchedule {
  final int id;
  final String title;
  final String body;
  final int hour;
  final int minute;
  final String? imagePath;

  NotificationSchedule({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'hour': hour,
    'minute': minute,
    'imagePath': imagePath,
  };

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) {
    return NotificationSchedule(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      imagePath: json['imagePath'] as String?,
    );
  }
}
