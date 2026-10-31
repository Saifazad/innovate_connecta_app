import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:innovate_connecta_app/features/contact/models/contact_request.dart';
import 'package:innovate_connecta_app/features/contact/models/contact_response.dart';
import 'package:innovate_connecta_app/features/contact/repository/contact_repository.dart';
import 'package:innovate_connecta_app/features/contact/view_models/contact_view_model.dart';

void main() {
  const successJson = '''
  {
    "status": true,
    "message": "Thank you for reaching out! An advisor will get back to you within 24 hours.",
    "data": {
      "id": 10,
      "name": "Vikram Sharma",
      "email": "vikram@example.com",
      "phone": "9810660607",
      "subject": "General Inquiry",
      "created_at": "2026-10-26T09:55:26.000000Z"
    }
  }
  ''';

  const validationErrorJson = '''
  {
    "status": false,
    "message": "Validation error",
    "errors": {
      "name": ["Please enter your full name."],
      "phone": ["Please enter your phone number."]
    }
  }
  ''';

  group('Contact Models & Deserialization Tests', () {
    test('ContactRequest serializes to JSON properly', () {
      const request = ContactRequest(
        name: 'Vikram Sharma',
        email: 'vikram@example.com',
        phone: '9810660607',
        subject: 'General Inquiry',
        message: 'Hello, this is a test',
      );

      final json = request.toJson();
      expect(json['name'], 'Vikram Sharma');
      expect(json['email'], 'vikram@example.com');
      expect(json['phone'], '9810660607');
      expect(json['subject'], 'General Inquiry');
      expect(json['message'], 'Hello, this is a test');
    });

    test('ContactResponse parses success response correctly', () {
      final jsonMap = jsonDecode(successJson) as Map<String, dynamic>;
      final response = ContactResponse.fromJson(jsonMap);

      expect(response.status, true);
      expect(response.message,
          'Thank you for reaching out! An advisor will get back to you within 24 hours.');
      expect(response.data, isNotNull);
      expect(response.data?.name, 'Vikram Sharma');
      expect(response.data?.id, 10);
      expect(response.errors.isEmpty, true);
    });

    test('ContactResponse parses validation errors correctly', () {
      final jsonMap = jsonDecode(validationErrorJson) as Map<String, dynamic>;
      final response = ContactResponse.fromJson(jsonMap);

      expect(response.status, false);
      expect(response.message, 'Validation error');
      expect(response.firstErrorFor('name'), 'Please enter your full name.');
      expect(response.firstErrorFor('phone'), 'Please enter your phone number.');
      expect(response.firstErrorFor('email'), isNull);
    });
  });

  group('Contact Repository Tests', () {
    test('submitContactForm returns success on 200 OK', () async {
      final mockClient = MockClient((request) async {
        return http.Response(successJson, 200,
            headers: {'content-type': 'application/json'});
      });

      final repo = ContactRepository(client: mockClient);
      final res = await repo.submitContactForm(const ContactRequest(
        name: 'Vikram',
        email: 'vikram@test.com',
        phone: '9810660607',
        subject: 'General Inquiry',
        message: 'Hello',
      ));

      expect(res.status, true);
      expect(res.data?.id, 10);
    });

    test('submitContactForm parses 422 validation errors properly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(validationErrorJson, 422,
            headers: {'content-type': 'application/json'});
      });

      final repo = ContactRepository(client: mockClient);
      final res = await repo.submitContactForm(const ContactRequest(
        name: '',
        email: 'vikram@test.com',
        phone: '',
        subject: 'General Inquiry',
        message: 'Hello',
      ));

      expect(res.status, false);
      expect(res.firstErrorFor('name'), isNotNull);
    });
  });

  group('Contact ViewModel Tests', () {
    test('submitForm performs client side validation', () async {
      final vm = ContactViewModel();

      // Submit with empty inputs
      final success = await vm.submitForm(
        name: '',
        email: '',
        phone: '',
        message: '',
      );

      expect(success, false);
      expect(vm.fieldErrors.containsKey('name'), true);
      expect(vm.fieldErrors.containsKey('email'), true);
      expect(vm.fieldErrors.containsKey('phone'), true);
      expect(vm.fieldErrors.containsKey('subject'), true);
      expect(vm.fieldErrors.containsKey('message'), true);
    });

    test('submitForm succeeds with valid inputs and repository response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(successJson, 200,
            headers: {'content-type': 'application/json'});
      });

      final repo = ContactRepository(client: mockClient);
      final vm = ContactViewModel(repository: repo);

      vm.setSubject('General Inquiry');
      final success = await vm.submitForm(
        name: 'Vikram Sharma',
        email: 'vikram@example.com',
        phone: '9810660607',
        message: 'Hello, this is a test inquiry message.',
      );

      expect(success, true);
      expect(vm.successMessage, isNotNull);
      expect(vm.fieldErrors.isEmpty, true);
    });
  });
}
