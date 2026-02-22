import 'package:intl/intl.dart';

/// Date and time formatting utilities
class DateFormatters {
  DateFormatters._();

  /// Format time remaining as HH:MM:SS
  static String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format time remaining as human readable
  static String formatDurationReadable(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '$hours hr ${minutes}min';
      }
      return '$hours hr';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      if (seconds > 0) {
        return '$minutes min ${seconds}s';
      }
      return '$minutes min';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Format countdown timer (large display)
  static String formatCountdown(Duration duration) {
    if (duration.inSeconds <= 0) return '00';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return seconds.toString();
  }

  /// Format date as MMMM d, yyyy (e.g., January 15, 2024)
  static String formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  /// Format date as short format (e.g., Jan 15)
  static String formatDateShort(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Format date and time (e.g., Jan 15, 2024 at 3:30 PM)
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(date);
  }

  /// Format time (e.g., 3:30 PM)
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "in 5 minutes")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      // Past
      final absDiff = difference.abs();
      if (absDiff.inSeconds < 60) {
        return 'just now';
      } else if (absDiff.inMinutes < 60) {
        final mins = absDiff.inMinutes;
        return '${mins}min ago';
      } else if (absDiff.inHours < 24) {
        final hours = absDiff.inHours;
        return '${hours}hr ago';
      } else if (absDiff.inDays < 7) {
        final days = absDiff.inDays;
        return '$days day${days > 1 ? 's' : ''} ago';
      } else {
        return formatDateShort(date);
      }
    } else {
      // Future
      if (difference.inSeconds < 60) {
        return 'in a moment';
      } else if (difference.inMinutes < 60) {
        final mins = difference.inMinutes;
        return 'in ${mins}min';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return 'in ${hours}hr';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return 'in $days day${days > 1 ? 's' : ''}';
      } else {
        return formatDateShort(date);
      }
    }
  }

  /// Format last check-in time
  static String formatLastCheckIn(DateTime? lastCheckIn) {
    if (lastCheckIn == null) {
      return 'Never checked in';
    }
    return 'Last check-in: ${formatRelative(lastCheckIn)}';
  }

  /// Format next check-in time
  static String formatNextCheckIn(DateTime nextCheckIn) {
    return 'Next check-in: ${formatRelative(nextCheckIn)}';
  }

  /// Format date for storage
  static String formatForStorage(DateTime date) {
    return date.toIso8601String();
  }

  /// Parse date from storage
  static DateTime? parseFromStorage(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  /// Format date for display in away mode
  static String formatAwayModeDate(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}
