import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:innovate_connecta_app/features/sessions/models/recorded_session_model.dart';
import 'package:innovate_connecta_app/features/sessions/repository/sessions_repository.dart';
import 'package:innovate_connecta_app/features/sessions/views/course_preview_screen.dart';
import 'package:innovate_connecta_app/features/sessions/views/course_checkout_screen.dart';
import 'package:innovate_connecta_app/features/sessions/views/course_payment_success_screen.dart';
import 'package:innovate_connecta_app/features/sessions/widgets/vertical_recorded_session_card.dart';
import 'package:innovate_connecta_app/features/sessions/widgets/horizontal_recorded_session_card.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  final testSession = RecordedSessionModel(
    id: 12,
    categoryId: 15,
    title: 'System Design & Scalable Architecture',
    slug: 'system-design-scalable-architecture',
    categoryName: 'System Design',
    heading: 'Learn to design scalable, reliable and production-ready software systems.',
    duration: '14 Hours',
    lessons: '18 Lessons',
    discountPrice: '₹3,999',
    originalPrice: '₹4,999',
    rating: 4.9,
    courseOverview:
        'Learn the fundamentals of System Design and understand how large-scale software applications are designed and built.',
    whatYouWillLearn:
        'Understand Low-Level Design and High-Level Design<br>Learn scalability and distributed system concepts<br>Design REST APIs and scalable backend services',
    instructorName: 'Kaif Alam',
    instructorDesignation: 'Full Stack Web Development Instructor',
    instructorExperience: '3+ Years Industry Experience in Web Development',
    instructorBio:
        'Full Stack Developer and mentor specializing in React, Node.js, Express.js, MongoDB, and modern web application development.',
  );

  group('CoursePreviewScreen Tests', () {
    testWidgets('renders all course preview elements accurately', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: CoursePreviewScreen(session: testSession, autoFetchDetails: false),
        ),
      );
      await tester.pumpAndSettle();

      // Header App Bar
      expect(find.text('INNOVATE CONNECTA'), findsOneWidget);
      expect(find.text('Course Preview'), findsOneWidget);

      // Category, Title, Subtitle
      expect(find.text('System Design'), findsOneWidget);
      expect(find.text('System Design & Scalable Architecture'), findsOneWidget);
      expect(
        find.text('Learn to design scalable, reliable and production-ready software systems.'),
        findsOneWidget,
      );

      // Meta and Pricing
      expect(find.text('Comprehensive'), findsOneWidget);
      expect(find.text('₹3,999'), findsWidgets);
      expect(find.text('₹4,999'), findsWidgets);

      // CTA Buttons
      expect(find.text('Buy Course & Enroll Now'), findsWidgets);
      expect(find.text('Watch Preview'), findsOneWidget);

      // Tabs
      expect(find.text('Course Overview'), findsOneWidget);
      expect(find.text("What You'll Learn"), findsOneWidget);
      expect(find.text('About Instructor'), findsOneWidget);

      // Course Overview Card Content
      expect(find.text('About This Masterclass'), findsOneWidget);
      expect(find.text('INSTANT ACCESS'), findsOneWidget);
      expect(find.text('Secure 256-bit'), findsOneWidget);
      expect(find.text('Kaif Alam'), findsOneWidget);
      expect(find.text('Full Stack Web Development Instructor'), findsOneWidget);
      expect(find.text('Share This Course'), findsOneWidget);

      // Sticky Bottom Bar
      expect(find.text('TOTAL PRICE'), findsOneWidget);
      expect(find.text('Enroll Now'), findsOneWidget);
    });

    testWidgets('switching tabs displays What You Will Learn and About Instructor', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: CoursePreviewScreen(session: testSession, autoFetchDetails: false),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to What You'll Learn tab
      await tester.tap(find.text("What You'll Learn"));
      await tester.pumpAndSettle();
      expect(find.text('Understand Low-Level Design and High-Level Design'), findsOneWidget);
      expect(find.text('Learn scalability and distributed system concepts'), findsOneWidget);

      // Switch to About Instructor tab
      await tester.tap(find.text('About Instructor'));
      await tester.pumpAndSettle();
      expect(find.text('Instructor Biography'), findsOneWidget);
      expect(find.text('3+ Years Industry Experience in Web Development'), findsOneWidget);
    });

    testWidgets('tapping Watch Preview opens preview dialog', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: CoursePreviewScreen(session: testSession, autoFetchDetails: false),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Watch Preview'));
      await tester.pumpAndSettle();

      expect(find.text('Close Preview'), findsOneWidget);
      await tester.tap(find.text('Close Preview'));
      await tester.pumpAndSettle();
      expect(find.text('Close Preview'), findsNothing);
    });

    testWidgets('tapping Buy Course & Enroll Now opens bottom sheet and confirms enrollment', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: CoursePreviewScreen(session: testSession, autoFetchDetails: false),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enroll Now'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Enrollment'), findsOneWidget);
      expect(find.text('Pay ₹3,999 & Enroll Now'), findsOneWidget);

      await tester.tap(find.text('Pay ₹3,999 & Enroll Now'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Enrollment'), findsNothing);
      expect(find.text('Enrolled'), findsOneWidget);
    });

    testWidgets('VerticalRecordedSessionCard navigates to CoursePreviewScreen when Preview Course is tapped', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalRecordedSessionCard(session: testSession),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Preview Course'));
      await tester.pumpAndSettle();

      expect(find.byType(CoursePreviewScreen), findsOneWidget);
      expect(find.text('About This Masterclass'), findsOneWidget);
    });

    testWidgets('HorizontalRecordedSessionCard navigates to CoursePreviewScreen when Preview Course is tapped', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalRecordedSessionCard(session: testSession),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Preview Course'), findsOneWidget);
      await tester.tap(find.text('Preview Course'));
      await tester.pumpAndSettle();

      expect(find.byType(CoursePreviewScreen), findsOneWidget);
      expect(find.text('About This Masterclass'), findsOneWidget);
    });

    test('SessionsRepository calls exact slug endpoint with email and user_id', () async {
      Uri? capturedUri;
      final mockClient = MockClient((request) async {
        capturedUri = request.url;
        return http.Response(
          jsonEncode({
            'status': true,
            'data': {
              'id': 12,
              'title': 'System Design & Scalable Architecture',
              'slug': 'system-design-scalable-architecture',
              'category': {'name': 'System Design'},
              'heading': 'Learn to design scalable systems',
              'duration': '14 Hours',
              'lessons': '18 Lessons',
              'discount_price': '3999',
              'original_price': '4999',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = SessionsRepository(client: mockClient);
      final session = await repo.fetchRecordedSessionDetails(
        slug: 'system-design-scalable-architecture',
        email: 'apitest@gmail.com',
        userId: 7,
      );

      expect(session, isNotNull);
      expect(session!.title, 'System Design & Scalable Architecture');
      expect(capturedUri, isNotNull);
      expect(
        capturedUri.toString(),
        'https://awsdemo.co.in/innovateconnect/api/v1/recorded-sessions/system-design-scalable-architecture?email=apitest%40gmail.com&user_id=7',
      );
    });

    testWidgets('CoursePreviewScreen renders safely when initialized with slug only', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: CoursePreviewScreen(
            slug: 'system-design-scalable-architecture',
            autoFetchDetails: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('System Design & Scalable Architecture'), findsOneWidget);
      expect(find.text('Course Preview'), findsOneWidget);
    });

    testWidgets('CourseCheckoutScreen renders accurately with Order Summary and Payment Options', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: CourseCheckoutScreen(session: testSession),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Secure Checkout'), findsOneWidget);
      expect(find.text('100% Encrypted'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Student Contact Information'), findsOneWidget);
      expect(find.text('Payment Option'), findsOneWidget);
      expect(find.text('Online Net Banking'), findsOneWidget);
      expect(find.text('Selected'), findsOneWidget);
      expect(find.text('HDFC Bank'), findsOneWidget);
      expect(find.textContaining('Pay ₹3,999 & Unlock Masterclass'), findsOneWidget);
    });

    testWidgets('CoursePaymentSuccessScreen renders confirmation details and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: CoursePaymentSuccessScreen(
            session: testSession,
            studentName: 'Test',
            studentEmail: 'test1234@gmail.com',
            bankName: 'HDFC Bank',
            totalPaid: '₹3999',
            orderId: 'REC-20261021-7W0SYS',
            transactionId: 'TXN-20261021051614-QYHR',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment Confirmed!'), findsOneWidget);
      expect(find.textContaining('Thank you Test!'), findsOneWidget);
      expect(find.text('Order ID:'), findsOneWidget);
      expect(find.text('REC-20261021-7W0SYS'), findsOneWidget);
      expect(find.text('Transaction ID:'), findsOneWidget);
      expect(find.text('TXN-20261021051614-QYHR'), findsOneWidget);
      expect(find.text('Total Paid:'), findsOneWidget);
      expect(find.text('₹3999.00'), findsOneWidget);
      expect(find.text('Watch Masterclass Now'), findsOneWidget);
      expect(find.text('Print Invoice'), findsOneWidget);
    });
  });
}
