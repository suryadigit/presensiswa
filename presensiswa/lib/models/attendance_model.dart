class Attendance {
  final String name;
  final String className;
  final String time;

  Attendance({required this.name, required this.className, required this.time});

  Map<String, String> toMap() {
    return {
      'name': name,
      'className': className,
      'time': time,
    };
  }
}
