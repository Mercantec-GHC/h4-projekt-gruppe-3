class Task {
  int id;
  String title;
  String description;
  int reward;
  DateTime startDate;
  DateTime endDate;
  bool recurring;
  int recurringInterval;
  bool singleCompletion;

  Task(
    this.id,
    this.title,
    this.description,
    this.reward,
    this.startDate,
    this.endDate,
    this.recurring,
    this.recurringInterval,
    this.singleCompletion
  );
}
