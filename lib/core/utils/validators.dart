/// Form field validators
class Validators {
  Validators._();

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Remove common separators
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return 'Please enter a valid phone number';
    }
    if (!RegExp(r'^\d+$').hasMatch(cleanPhone)) {
      return 'Phone number should only contain digits';
    }
    return null;
  }

  /// Validate name
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  /// Validate required field
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate date of birth
  static String? dateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }
    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Please enter a valid date';
    }
    final now = DateTime.now();
    final age = now.year - date.year;
    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    if (age > 120) {
      return 'Please enter a valid date of birth';
    }
    return null;
  }

  /// Validate blood group
  static String? bloodGroup(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a blood group';
    }
    final validGroups = [
      'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown'
    ];
    if (!validGroups.contains(value)) {
      return 'Please select a valid blood group';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validate confirmation password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate relationship
  static String? relationship(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a relationship';
    }
    return null;
  }

  /// Validate destination address
  static String? destination(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a destination';
    }
    if (value.trim().length < 3) {
      return 'Please enter a valid destination';
    }
    return null;
  }

  /// Validate estimated time
  static String? estimatedMinutes(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter estimated time';
    }
    final minutes = int.tryParse(value);
    if (minutes == null) {
      return 'Please enter a valid number';
    }
    if (minutes < 1) {
      return 'Time must be at least 1 minute';
    }
    if (minutes > 120) {
      return 'Time cannot exceed 120 minutes';
    }
    return null;
  }
}
