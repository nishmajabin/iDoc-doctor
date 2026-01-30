class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email!';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password!';
    }
    return null;
  }

  static String? nameValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Only alphabets are allowed';
    }
    
    if (value.trim().length < 4) {
      return 'Require at least 4 characters long';
    }
    
    return null;
  }

  static String? strongPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least 1 lowercase letter';
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least 1 number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }

    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please enter Password to confirm';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName!';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    
    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }
    
    return null;
  }

  static String? placeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your place';
    }
    
    if (value.trim().length < 2) {
      return 'Place name is too short';
    }
    
    return null;
  }

  static String? specialistValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your specialist field';
    }
    
    if (value.trim().length < 3) {
      return 'Specialist field is too short';
    }
    
    return null;
  }

  static String? bioValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your bio';
    }
    
    if (value.trim().length < 10) {
      return 'Bio must be at least 10 characters';
    }
    
    if (value.trim().length > 500) {
      return 'Bio is too long (max 500 characters)';
    }
    
    return null;
  }

  static String? licenseNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your license number';
    }
    
    if (value.trim().length < 5) {
      return 'License number is too short';
    }
    
    return null;
  }

  static String? experienceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your experience';
    }
    
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.isEmpty) {
      return 'Please enter a valid number';
    }
    
    final years = int.tryParse(digitsOnly);
    
    if (years == null || years < 0) {
      return 'Please enter valid years of experience';
    }
    
    if (years > 70) {
      return 'Experience seems too high';
    }
    
    return null;
  }
}