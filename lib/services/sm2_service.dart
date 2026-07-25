import 'dart:math';

/// SM-2 Spaced Repetition Item Record
class SM2Item {
  final String id;
  final int repetitions;
  final int interval; // in days
  final double easeFactor;
  final DateTime nextReviewAt;

  SM2Item({
    required this.id,
    required this.repetitions,
    required this.interval,
    required this.easeFactor,
    required this.nextReviewAt,
  });

  factory SM2Item.initial(String id) {
    return SM2Item(
      id: id,
      repetitions: 0,
      interval: 1,
      easeFactor: 2.5,
      nextReviewAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'repetitions': repetitions,
      'interval': interval,
      'easeFactor': easeFactor,
      'nextReviewAt': nextReviewAt.toIso8601String(),
    };
  }

  factory SM2Item.fromJson(Map<String, dynamic> json) {
    return SM2Item(
      id: json['id'] as String,
      repetitions: json['repetitions'] as int? ?? 0,
      interval: json['interval'] as int? ?? 1,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      nextReviewAt: json['nextReviewAt'] != null
          ? DateTime.parse(json['nextReviewAt'] as String)
          : DateTime.now(),
    );
  }
}

/// Rating quality: 0 (Again/Forgot), 3 (Hard), 4 (Good), 5 (Easy)
enum SM2Rating {
  again(0),
  hard(3),
  good(4),
  easy(5);

  final int value;
  const SM2Rating(this.value);
}

class SM2Service {
  /// Calculates the next review date and parameters using SM-2 algorithm.
  static SM2Item calculateNextReview(SM2Item current, SM2Rating rating) {
    final q = rating.value;
    int reps = current.repetitions;
    int interval = current.interval;
    double ef = current.easeFactor;

    if (q >= 3) {
      if (reps == 0) {
        interval = 1;
      } else if (reps == 1) {
        interval = 6;
      } else {
        interval = (interval * ef).round();
      }
      reps += 1;
    } else {
      reps = 0;
      interval = 1;
    }

    // Update Ease Factor (EF)
    ef = ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
    if (ef < 1.3) ef = 1.3;

    final nextReview = DateTime.now().add(Duration(days: interval));

    return SM2Item(
      id: current.id,
      repetitions: reps,
      interval: interval,
      easeFactor: double.parse(ef.toStringAsFixed(2)),
      nextReviewAt: nextReview,
    );
  }
}
