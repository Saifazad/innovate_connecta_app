import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovate_connecta_app/features/sessions/models/live_session_model.dart';
import 'package:innovate_connecta_app/features/sessions/models/recorded_session_model.dart';
import 'package:innovate_connecta_app/features/sessions/views/sessions_screen.dart';
import 'package:innovate_connecta_app/features/sessions/widgets/horizontal_live_session_card.dart';
import 'package:innovate_connecta_app/features/sessions/widgets/horizontal_recorded_session_card.dart';
import 'package:innovate_connecta_app/features/sessions/widgets/vertical_recorded_session_card.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Sessions Widget Rendering & Layout Tests', () {
    testWidgets('HorizontalRecordedSessionCard renders cleanly without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final session = RecordedSessionModel(
        id: 12,
        categoryId: 15,
        title: 'System Design & Scalable Architecture',
        categoryName: 'System Design',
        heading: 'Learn to design scalable, reliable and production-ready software systems.',
        duration: '14 Hours',
        lessons: '18 Lessons',
        discountPrice: '₹3,999',
        originalPrice: '₹4,999',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 310,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  HorizontalRecordedSessionCard(session: session),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('System Design & Scalable Architecture'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('HorizontalLiveSessionCard renders cleanly without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final session = LiveSessionModel(
        id: 8,
        title: 'Master class on Python full stack',
        categoryName: 'Web Development',
        date: '2 Hours',
        fee: '₹19',
        originalFee: '₹99',
        description: 'Python full stack development',
        schedule: 'Live',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 285,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  HorizontalLiveSessionCard(session: session),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Master class on Python full stack'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('VerticalRecordedSessionCard renders cleanly without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final session = RecordedSessionModel(
        id: 12,
        categoryId: 15,
        title: 'System Design & Scalable Architecture',
        categoryName: 'System Design',
        heading: 'Learn to design scalable, reliable and production-ready software systems.',
        duration: '14 Hours',
        lessons: '18 Lessons',
        discountPrice: '₹3,999',
        originalPrice: '₹4,999',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                VerticalRecordedSessionCard(session: session),
              ],
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('System Design & Scalable Architecture'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SessionsScreen section headers render cleanly without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: SessionsScreen(),
        ),
      );

      await tester.pump();
      expect(find.text('Live Sessions'), findsOneWidget);
      expect(find.text('Recorded Sessions'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
