import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovate_connecta_app/features/dashboard/views/dashboard_screen.dart';
import 'package:innovate_connecta_app/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:innovate_connecta_app/shared/widgets/app_stat_card.dart';
import 'package:innovate_connecta_app/features/dashboard/widgets/dashboard_live_card.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('DashboardScreen Tests', () {
    test('DashboardViewModel initial state and defaults', () {
      final vm = DashboardViewModel();
      expect(vm.liveSessionsCount, equals(3));
      expect(vm.recordedSessionsCount, equals(5));
      expect(vm.resourcesCount, equals(8));
      expect(vm.certificatesCount, equals(2));
      expect(vm.greetingName.isNotEmpty, isTrue);
      expect(vm.upcomingLiveSessions.length, equals(3));
    });

    testWidgets('DashboardScreen renders all cards, greeting and sections',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final vm = DashboardViewModel();

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(viewModel: vm),
        ),
      );
      await tester.pumpAndSettle();

      // Top App Bar
      expect(find.text('My Dashboard'), findsOneWidget);

      // Greeting with name
      expect(
        find.textContaining('Welcome back'),
        findsOneWidget,
      );

      // 4 Stat Cards
      expect(find.byType(AppStatCard), findsNWidgets(4));
      expect(find.text('Live Sessions'), findsOneWidget);
      expect(find.text('Recordings'), findsOneWidget);
      expect(find.text('Resources'), findsOneWidget);
      expect(find.text('Certificates'), findsOneWidget);

      // Section: Upcoming Live Sessions
      expect(find.text('Upcoming Live Sessions'), findsOneWidget);
      expect(find.text('Your registered live classes and webinars'), findsOneWidget);
      expect(find.text('View All '), findsOneWidget);
      expect(find.byType(DashboardLiveCard), findsWidgets);

      // Section: Purchased Recorded Sessions
      expect(find.text('Purchased Recorded Sessions'), findsOneWidget);
      expect(find.text('Watch your purchased session recordings'), findsOneWidget);
      expect(find.text('No Purchased Recorded Sessions Yet'), findsOneWidget);
      expect(find.text('Explore Masterclasses'), findsOneWidget);
    });
  });
}

