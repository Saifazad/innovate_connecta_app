import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innovate_connecta_app/features/services/views/services_screen.dart';
import 'package:innovate_connecta_app/features/services/constants/services_strings.dart';
import 'package:innovate_connecta_app/shared/widgets/brand_logo.dart';

void main() {
  testWidgets('ServicesScreen renders header, title, and all 6 service cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ServicesScreen(),
      ),
    );

    // Verify top bar and title
    expect(find.byType(BrandLogo), findsOneWidget);
    expect(find.text('Our Services'), findsOneWidget);
    expect(find.text(ServicesStrings.subtitle), findsOneWidget);

    // Verify benefits in Upskilling Programs
    expect(find.text(ServicesStrings.benefitsHeader), findsOneWidget);
    expect(find.text('Industry Exposure'), findsOneWidget);
    expect(find.text('Career Clarity'), findsOneWidget);

    // Verify all 6 service titles
    expect(find.text(ServicesStrings.careerGuidanceTitle), findsOneWidget);
    expect(find.text(ServicesStrings.upskillingTitle), findsOneWidget);
    expect(find.text(ServicesStrings.workshopsTitle), findsOneWidget);
    expect(find.text(ServicesStrings.internshipTitle), findsOneWidget);
    expect(find.text(ServicesStrings.corporateTitle), findsOneWidget);
    expect(find.text(ServicesStrings.resourcesTitle), findsOneWidget);

    // Verify tags
    expect(find.text(ServicesStrings.tagMentorship), findsOneWidget);
    expect(find.text(ServicesStrings.tagLiveCourses), findsOneWidget);
    expect(find.text(ServicesStrings.tagSoft), findsOneWidget);
    expect(find.text(ServicesStrings.tagTechnical), findsOneWidget);
    expect(find.text(ServicesStrings.tagPlacement), findsOneWidget);
    expect(find.text(ServicesStrings.tagTop), findsOneWidget);
    expect(find.text(ServicesStrings.tagTeamTraining), findsOneWidget);
    expect(find.text(ServicesStrings.tagDigitalLibrary), findsOneWidget);

    // Verify back button is present
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
  });
}
