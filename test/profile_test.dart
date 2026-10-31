import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:innovate_connecta_app/core/network/api_client.dart';
import 'package:innovate_connecta_app/core/services/database_service.dart';
import 'package:innovate_connecta_app/features/profile/views/profile_screen.dart';
import 'package:innovate_connecta_app/features/profile/views/security_screen.dart';
import 'package:innovate_connecta_app/features/profile/models/student_profile_model.dart';
import 'package:innovate_connecta_app/features/profile/models/certificate_model.dart';
import 'package:innovate_connecta_app/features/profile/models/resume_model.dart';
import 'package:innovate_connecta_app/features/profile/models/change_password_request.dart';
import 'package:innovate_connecta_app/features/profile/models/feedback_request_model.dart';

import 'package:innovate_connecta_app/features/profile/repository/certificates_repository.dart';
import 'package:innovate_connecta_app/features/profile/repository/resume_repository.dart';
import 'package:innovate_connecta_app/features/profile/repository/feedback_repository.dart';

import 'package:innovate_connecta_app/features/profile/view_models/profile_view_model.dart';
import 'package:innovate_connecta_app/features/profile/view_models/certificates_view_model.dart';
import 'package:innovate_connecta_app/features/profile/view_models/resume_view_model.dart';
import 'package:innovate_connecta_app/features/profile/view_models/security_view_model.dart';
import 'package:innovate_connecta_app/features/profile/view_models/feedback_view_model.dart';

void main() {
  group('Student Profile Tests', () {
    test(
      'StudentProfileModel default values and copyWith work as expected',
      () {
        final defaultProfile = StudentProfileModel.defaultProfile;
        expect(defaultProfile.name, 'Amar Sharma');
        expect(defaultProfile.email, 'amar.sharma@example.com');
        expect(defaultProfile.isMsmeVerified, true);
        expect(defaultProfile.cohort, 'Cohort 2024');

        final updatedProfile = defaultProfile.copyWith(
          name: 'Rohit Verma',
          university: 'IIT Delhi',
          isEmailVerified: false,
        );

        expect(updatedProfile.name, 'Rohit Verma');
        expect(updatedProfile.university, 'IIT Delhi');
        expect(updatedProfile.isEmailVerified, false);
        expect(updatedProfile.phone, defaultProfile.phone);
        expect(
          updatedProfile.programTitle,
          'B.Tech Computer Science • Final Year',
        );
      },
    );

    test(
      'ProfileViewModel updates fields correctly and notifies listeners',
      () async {
        final vm = ProfileViewModel();
        expect(vm.profile.name, 'Amar Sharma');

        int notifyCount = 0;
        vm.addListener(() {
          notifyCount++;
        });

        await vm.updateField(name: 'Aarav Patel', university: 'BITS Pilani');
        expect(vm.profile.name, 'Aarav Patel');
        expect(vm.profile.university, 'BITS Pilani');
        expect(notifyCount, 1);

        await vm.updateField(degree: 'M.Tech AI', year: '1st Year');
        expect(vm.profile.degree, 'M.Tech AI');
        expect(vm.profile.year, '1st Year');
        expect(vm.profile.programTitle, 'M.Tech AI • 1st Year');
        expect(notifyCount, 2);
      },
    );
  });

  group('Certificates Dummy API & ViewModel Tests', () {
    test('CertificateModel serializes and deserializes properly', () {
      final cert = CertificateModel(
        id: '1',
        title: 'Python Programming Basics',
        issuer: 'Innovate Connect Academy',
        type: 'Live Session Certificate',
        issuedDate: '12 Aug 2025',
        certificateId: 'ICA-PY-2025-00123',
        isValid: true,
        isVerified: true,
      );

      final json = cert.toJson();
      expect(json['id'], '1');
      expect(json['title'], 'Python Programming Basics');
      expect(json['is_verified'], true);

      final parsed = CertificateModel.fromJson(json);
      expect(parsed.id, cert.id);
      expect(parsed.title, cert.title);
      expect(parsed.issuer, cert.issuer);
      expect(parsed.isVerified, cert.isVerified);
    });

    test(
      'CertificatesRepository returns simulated dummy certificate data',
      () async {
        final repo = CertificatesRepository();
        final certificates = await repo.fetchCertificates();

        expect(certificates.isNotEmpty, true);
        expect(certificates.length, 2);
        expect(certificates.first.title, 'Python Programming Basics');
        expect(certificates.last.title, 'Web Development Bootcamp');
      },
    );

    test(
      'CertificatesViewModel loads certificates and updates state',
      () async {
        final vm = CertificatesViewModel();
        expect(vm.isLoading, false);
        expect(vm.certificates.isEmpty, true);

        await vm.loadCertificates();

        expect(vm.isLoading, false);
        expect(vm.certificates.length, 2);
        expect(vm.certificateCount, 2);
        expect(vm.errorMessage, isNull);
      },
    );
  });

  group('Resume Model, Repository & ViewModel Tests', () {
    setUp(() {
      DatabaseService.instance.reset();
    });
    test('ResumeModel serializes and deserializes properly', () {
      final model = ResumeModel(
        id: 'res-1',
        fileName: 'Resume.pdf',
        fileSize: '1.4 MB',
        title: 'Resume',
        uploadedAt: 'Upk',
        isVerified: true,
      );

      final json = model.toJson();
      expect(json['file_name'], 'Resume.pdf');
      expect(json['is_verified'], true);

      final parsed = ResumeModel.fromJson(json);
      expect(parsed.fileName, 'Resume.pdf');
      expect(parsed.fileSize, '1.4 MB');
      expect(parsed.isVerified, true);
    });

    test('ResumeRepository fetches and saves active resume', () async {
      final repo = ResumeRepository();
      final initial = await repo.fetchActiveResume();
      expect(initial?.fileName, 'Resume.pdf');

      const updated = ResumeModel(
        id: 'res-custom',
        fileName: 'custom_cv.pdf',
        fileSize: '2.1 MB',
        title: 'Software Engineer CV',
        uploadedAt: 'Today',
      );

      final saved = await repo.saveResume(updated);
      expect(saved, true);

      final current = await repo.fetchActiveResume();
      expect(current?.fileName, 'custom_cv.pdf');
      expect(current?.title, 'Software Engineer CV');
    });

    test('ResumeViewModel initial state has active resume', () {
      final vm = ResumeViewModel();
      expect(vm.activeResume.fileName, 'Resume.pdf');
      expect(vm.activeResume.isVerified, true);
      expect(vm.selectedFileName, isNull);
    });

    test('ResumeViewModel handles removeSelectedFile and clearMessages', () {
      final vm = ResumeViewModel();
      vm.removeSelectedFile();
      expect(vm.selectedFileName, isNull);
      expect(vm.selectedFilePath, isNull);
      expect(vm.selectedFileBytes, isNull);

      vm.clearMessages();
      expect(vm.errorMessage, isNull);
      expect(vm.successMessage, isNull);
    });

    test('ResumeViewModel upload without selection sets error', () async {
      final vm = ResumeViewModel();
      final success = await vm.uploadResume(title: 'My Resume');
      expect(success, false);
      expect(vm.errorMessage, contains('Please select a PDF resume file'));
    });
  });

  group('Security ViewModel & ChangePasswordRequest Tests', () {
    test('ChangePasswordRequest generates correct JSON payload', () {
      const request = ChangePasswordRequest(
        currentPassword: 'oldPassword123',
        newPassword: 'newPassword456',
        confirmPassword: 'newPassword456',
      );

      final json = request.toJson();
      expect(json['current_password'], 'oldPassword123');
      expect(json['new_password'], 'newPassword456');
      expect(json['new_password_confirmation'], 'newPassword456');
    });

    test('SecurityViewModel validates empty fields', () async {
      final vm = SecurityViewModel();
      final result = await vm.updatePassword(
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
      );

      expect(result, false);
      expect(vm.fieldErrors.containsKey('current'), true);
      expect(vm.fieldErrors.containsKey('new'), true);
      expect(vm.fieldErrors.containsKey('confirm'), true);
    });

    test(
      'SecurityViewModel enforces minimum 6 character password rule',
      () async {
        final vm = SecurityViewModel();
        final result = await vm.updatePassword(
          currentPassword: 'password123',
          newPassword: '123',
          confirmPassword: '123',
        );

        expect(result, false);
        expect(
          vm.fieldErrors['new'],
          'New password must be at least 6 characters',
        );
      },
    );

    test('SecurityViewModel checks password matching', () async {
      final vm = SecurityViewModel();
      final result = await vm.updatePassword(
        currentPassword: 'password123',
        newPassword: 'securePassword789',
        confirmPassword: 'differentPassword',
      );

      expect(result, false);
      expect(vm.fieldErrors['confirm'], 'Passwords do not match');
    });

    test('SecurityViewModel succeeds with valid inputs', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'status': true,
            'message': 'Your password has been updated successfully!',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final apiClient = ApiClient(client: mockClient);
      final vm = SecurityViewModel(apiClient: apiClient);
      final result = await vm.updatePassword(
        currentPassword: 'password123',
        newPassword: 'securePassword789',
        confirmPassword: 'securePassword789',
      );

      expect(result, true);
      expect(vm.fieldErrors.isEmpty, true);
      expect(vm.successMessage, 'Your password has been updated successfully!');
    });
  });

  group('Feedback Model, Repository & ViewModel Tests', () {
    test('FeedbackRequestModel generates expected API payload', () {
      const request = FeedbackRequestModel(
        name: 'Siddharth Verma',
        email: 'siddharth@example.com',
        sessionName: 'Web Development Bootcamp',
        keyTakeaway: 'Mastered Flutter and API integration',
        suggestions: 'More hands-on live code sessions',
        recommendation: 'Yes, Absolutely!',
      );

      final json = request.toJson();
      expect(json['name'], 'Siddharth Verma');
      expect(json['email'], 'siddharth@example.com');
      expect(json['session_name'], 'Web Development Bootcamp');
      expect(json['key_takeaway'], 'Mastered Flutter and API integration');
      expect(json['suggestions'], 'More hands-on live code sessions');
      expect(json['recommendation'], 'Yes, Absolutely!');
    });

    test(
      'FeedbackRepository successfully submits when API returns 200/201',
      () async {
        final mockClient = MockClient((request) async {
          expect(
            request.url.toString(),
            'https://awsdemo.co.in/innovateconnect/api/v1/feedback',
          );
          expect(request.method, 'POST');
          return http.Response(
            jsonEncode({
              'status': true,
              'message': 'Thank you! Your feedback has been received.',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final repo = FeedbackRepository(client: mockClient);
        const feedback = FeedbackRequestModel(
          name: 'Siddharth Verma',
          email: 'siddharth@example.com',
          sessionName: 'Web Development Bootcamp',
          keyTakeaway: 'Very informative session',
          recommendation: 'Yes, Absolutely!',
        );

        final result = await repo.submitFeedback(feedback);
        expect(result.status, true);
        expect(result.message, 'Thank you! Your feedback has been received.');
      },
    );

    test(
      'FeedbackRepository handles server 422 error response gracefully',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({
              'status': false,
              'message': 'The key takeaway field is required.',
            }),
            422,
            headers: {'content-type': 'application/json'},
          );
        });

        final repo = FeedbackRepository(client: mockClient);
        const feedback = FeedbackRequestModel(
          name: 'Siddharth Verma',
          email: 'siddharth@example.com',
          sessionName: 'Web Development Bootcamp',
          keyTakeaway: '',
        );

        final response = await repo.submitFeedback(feedback);
        expect(response.status, false);
        expect(response.message, contains('key takeaway field is required'));
      },
    );

    test(
      'FeedbackViewModel validates required fields and invalid email',
      () async {
        final vm = FeedbackViewModel();
        vm.setSession('Web Development Bootcamp');

        final invalidEmailResult = await vm.submitFeedback(
          name: 'Siddharth',
          email: 'invalid-email',
          keyTakeaway: 'Great session',
        );

        expect(invalidEmailResult, false);
        expect(vm.fieldErrors['email'], 'Please enter a valid email address');

        vm.setSession(null);
        final emptyFieldsResult = await vm.submitFeedback(
          name: '',
          email: '',
          keyTakeaway: '',
        );

        expect(emptyFieldsResult, false);
        expect(vm.fieldErrors.containsKey('name'), true);
        expect(vm.fieldErrors.containsKey('email'), true);
        expect(vm.fieldErrors.containsKey('session_name'), true);
        expect(vm.fieldErrors.containsKey('key_takeaway'), true);
      },
    );
  });

  group('Profile & Security Dropdown Widget Tests', () {
    testWidgets('ProfileScreen Settings tile drops down Change Password option', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(showBottomNav: false),
        ),
      );
      await tester.pump();

      // Initially Change Password sub-item is not visible
      expect(find.text('Change Password'), findsNothing);

      // Scroll to Settings and tap dropdown tile
      await tester.ensureVisible(find.text('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Now Change Password appears in dropdown
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Update account password'), findsOneWidget);

      // Tap Settings again to collapse
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsNothing);
    });

    testWidgets('SecurityScreen Change Password card drops down password form fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SecurityScreen(),
        ),
      );
      await tester.pump();

      // Header is visible
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Tap to expand & change password'), findsOneWidget);

      // Form fields and Update Password button are initially hidden
      expect(find.text('Current Password *'), findsNothing);
      expect(find.text('Update Password'), findsNothing);

      // Tap Change Password header to expand dropdown
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      // Form fields are now visible
      expect(find.text('Current Password *'), findsOneWidget);
      expect(find.text('New Password *'), findsOneWidget);
      expect(find.text('Confirm New Password *'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      // Tap Change Password header again to collapse
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      expect(find.text('Current Password *'), findsNothing);
      expect(find.text('Update Password'), findsNothing);
    });
  });
}
