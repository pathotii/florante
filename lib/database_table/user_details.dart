class UserDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String userType;

  UserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.userType,
  });

  // Convert UserDetails object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'user_type': userType,
    };
  }

  // Create a UserDetails object from a Map (database query)
  factory UserDetails.fromMap(Map<String, dynamic> map) {
    // Ensure that fields are never null, use default values if null
    return UserDetails(
      firstName: map['first_name'] ?? '',  // Default to empty string if null
      lastName: map['last_name'] ?? '',    // Default to empty string if null
      email: map['email'] ?? '',           // Default to empty string if null
      password: map['password'] ?? '',     // Default to empty string if null
      userType: map['user_type'] ?? 'Student', // Default to 'Student' if null
    );
  }
}
