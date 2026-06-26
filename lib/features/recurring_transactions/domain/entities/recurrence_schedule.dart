import 'recurring_transaction.dart';

class RecurrenceSchedule {
  const RecurrenceSchedule._();

  static DateTime calculateNextExecution({
    required RecurrenceFrequency frequency,
    required DateTime from,
  }) {
    final base = DateTime(from.year, from.month, from.day);

    return switch (frequency) {
      RecurrenceFrequency.daily => base.add(const Duration(days: 1)),
      RecurrenceFrequency.weekly => base.add(const Duration(days: 7)),
      RecurrenceFrequency.monthly => _addMonths(base, 1),
      RecurrenceFrequency.yearly => _addMonths(base, 12),
    };
  }

  static DateTime advanceUntilFuture({
    required RecurrenceFrequency frequency,
    required DateTime nextExecution,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(
      nextExecution.year,
      nextExecution.month,
      nextExecution.day,
    );

    while (next.isBefore(today)) {
      next = calculateNextExecution(frequency: frequency, from: next);
    }

    return next;
  }

  static bool isDue({
    required DateTime nextExecution,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return !nextExecution.isAfter(endOfToday);
  }

  static DateTime _addMonths(DateTime date, int months) {
    final totalMonths = date.month + months;
    final year = date.year + ((totalMonths - 1) ~/ 12);
    final month = ((totalMonths - 1) % 12) + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(year, month, day);
  }
}
