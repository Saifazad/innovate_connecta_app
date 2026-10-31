class ContactRequest {
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String message;

  const ContactRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'subject': subject.trim(),
      'message': message.trim(),
    };
  }
}
