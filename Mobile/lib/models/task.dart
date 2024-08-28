class Task {
  int id;
  String title;
  String description;
  int reward;
  DateTime endDate;
  bool recurring;
  int recurringInterval;
  bool singleCompletion;

  Task(
    this.id,
    this.title,
    this.description,
    this.reward,
    this.endDate,
    this.recurring,
    this.recurringInterval,
    this.singleCompletion
  );
}
