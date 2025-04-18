class UserSession {
  final String sessionToken;
  final String validId;
  final String currentTime;
  final int userId;
  final String fullName;
  final String username;
  final String lastName;
  final String firstName;
  final String profileName;

  UserSession({
    required this.sessionToken,
    required this.validId,
    required this.currentTime,
    required this.userId,
    required this.fullName,
    required this.username,
    required this.lastName,
    required this.firstName,
    required this.profileName,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      sessionToken: json['session_token'],
      validId: json['valid_id'],
      currentTime: json['glpi_currenttime'],
      userId: json['glpiID'],
      fullName: json['glpifriendlyname'],
      username: json['glpiname'],
      lastName: json['glpirealname'],
      firstName: json['glpifirstname'],
      profileName: json['glpiactiveprofile']['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_token': sessionToken,
      'valid_id': validId,
      'glpi_currenttime': currentTime,
      'glpiID': userId,
      'glpifriendlyname': fullName,
      'glpiname': username,
      'glpirealname': lastName,
      'glpifirstname': firstName,
      'glpiactiveprofile': {'name': profileName},
    };
  }
}