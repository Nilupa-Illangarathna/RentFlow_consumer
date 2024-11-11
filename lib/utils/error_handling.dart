// error_handling.dart

class ErrorHandling {
  static final Map<String, dynamic> signupErrors = {
    'name': {
      'required': 'Please enter your name.',
    },
    'age': {
      'required': 'Please enter your age.',
      'invalid': 'Invalid age format. \nPlease enter a valid number.',
    },
    'username': {
      'required': 'Please enter your username.',
    },
    'email': {
      'required': 'Please enter your email address.',
      'invalid': 'Invalid email format. \nPlease enter a valid email address.',
    },
    'mobile': {
      'required': 'Please enter your mobile number.',
      'invalid': 'Invalid mobile number format. \nPlease enter a valid mobile number.',
    },
    'password': {
      'required': 'Please enter your password.',
      'invalid': 'Password must contain at least 6 characters, \nUppercase letter and one special character.',
    },
  };

  static final Map<String, dynamic> loginErrors = {
    'username': {
      'required': 'Please enter your username.',
    },
    'password': {
      'required': 'Please enter your password.',
    },
    'general': {
      'invalidCredentials': 'Invalid username or password.',
      'serverError': 'An error occurred. Please try again later.',
    },
  };

  static final Map<String, dynamic> sentOtp = {
    'otpsend': {
      'email': 'The format of the email is incorrect.',
      'mobile': 'The format of the mobile number is incorrect.',
    },
  };

  static final Map<String, dynamic> resetPasswordErrors = {
    'password': {
      'required': 'Please enter your new password.',
      'invalid': 'Password must contain at least 6 characters, \nUppercase letter and one special character.',
    },
    'confirmPassword': {
      'required': 'Please confirm your new password.',
    },
  };
}
