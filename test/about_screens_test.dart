import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innovate_connecta_app/features/about/views/about_screen.dart';
import 'package:innovate_connecta_app/features/about/views/our_values_screen.dart';
import 'package:innovate_connecta_app/features/about/constants/about_strings.dart';

void main() {
  testWidgets(
    'AboutScreen renders all elements and navigates to OurValuesScreen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));

      // Verify top bar and header elements
      expect(find.text(AboutStrings.aboutUsTitle), findsOneWidget);
      expect(find.text(AboutStrings.msmeVerified), findsOneWidget);
      expect(find.text(AboutStrings.whoWeAre), findsOneWidget);

      // Verify badges
      expect(
        find.text(AboutStrings.highlightIndustryConnections),
        findsOneWidget,
      );
      expect(find.text(AboutStrings.highlightMsmeRegistered), findsOneWidget);
      expect(find.text(AboutStrings.highlightExpertMentorship), findsOneWidget);

      // Verify Vision, Mission, and Values cards
      expect(find.text(AboutStrings.visionTitle), findsOneWidget);
      expect(find.text(AboutStrings.missionTitle), findsOneWidget);
      expect(find.text(AboutStrings.valuesTitle), findsOneWidget);
      expect(find.text(AboutStrings.seeMore), findsOneWidget);

      // Tap See More to navigate to OurValuesScreen
      await tester.ensureVisible(find.text(AboutStrings.seeMore));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AboutStrings.seeMore));
      await tester.pumpAndSettle();

      // Verify OurValuesScreen is mounted
      expect(find.byType(OurValuesScreen), findsOneWidget);
      expect(find.text(AboutStrings.aboutOrganization), findsOneWidget);
      expect(find.text(AboutStrings.value1Title), findsOneWidget);
      expect(find.text(AboutStrings.value2Title), findsOneWidget);
      expect(find.text(AboutStrings.value3Title), findsOneWidget);
      expect(find.text(AboutStrings.value4Title), findsOneWidget);
      expect(find.text(AboutStrings.value5Title), findsOneWidget);
      expect(find.text(AboutStrings.value6Title), findsOneWidget);
      expect(find.text(AboutStrings.empowerBanner), findsOneWidget);

      // Tap back button to return to AboutScreen
      final backButtonFinder = find.byIcon(Icons.arrow_back_ios_new_rounded);
      expect(backButtonFinder, findsOneWidget);
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();

      // Verify back on AboutScreen
      expect(find.byType(AboutScreen), findsOneWidget);
    },
  );
}
