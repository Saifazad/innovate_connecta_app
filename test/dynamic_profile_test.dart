import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:innovate_connecta_app/core/services/database_service.dart';
import 'package:innovate_connecta_app/features/auth/models/auth_user.dart';
import 'package:innovate_connecta_app/features/home/widgets/home_drawer.dart';
import 'package:innovate_connecta_app/features/profile/models/student_profile_model.dart';
import 'package:innovate_connecta_app/features/profile/repository/profile_repository.dart';
import 'package:innovate_connecta_app/features/profile/view_models/profile_view_model.dart';
import 'package:innovate_connecta_app/features/profile/views/profile_screen.dart';

void main() {
  setUp(() {
    DatabaseService.resetInstance();
    ProfileRepository.resetInstance();
    ProfileViewModel.reset();
  });

  tearDown(() {
    DatabaseService.resetInstance();
    ProfileRepository.resetInstance();
    ProfileViewModel.reset();
  });

  group('Dynamic User Profile Model & Missing Details Tests', () {
    test('Shows "Add Education" when degree and year are empty', () {
      const profile = StudentProfileModel(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
        university: '',
        degree: '',
        year: '',
      );

      expect(profile.isEducationMissing, true);
      expect(profile.programTitle, 'Add Education');
      expect(profile.collegeTitle, 'Add College');
      expect(profile.isCollegeMissing, true);
    });

    test('Shows formatted degree and year when education details are provided', () {
      const profile = StudentProfileModel(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
        university: 'Delhi Technological University',
        degree: 'B.Tech Computer Science',
        year: 'Final Year',
      );

      expect(profile.isEducationMissing, false);
      expect(profile.programTitle, 'B.Tech Computer Science • Final Year');
      expect(profile.collegeTitle, 'Delhi Technological University');
      expect(profile.isCollegeMissing, false);
    });
  });

  group('Registration, Profile Updates, and Persistence Tests', () {
    test('User registration saves name, email, phone and sets active profile', () async {
      final vm = ProfileViewModel.instance;

      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
        field: 'College Student',
      );

      expect(vm.profile.name, 'Amir Khan');
      expect(vm.profile.email, 'amirkhan@example.com');
      expect(vm.profile.phone, '+91 9876543210');
      expect(vm.profile.programTitle, 'Add Education');
      expect(vm.profile.collegeTitle, 'Add College');
    });

    test('Profile updates save in database and notify listeners immediately', () async {
      final vm = ProfileViewModel.instance;

      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
      );

      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      await vm.updateField(
        degree: 'B.Tech Computer Science',
        year: 'Final Year',
        university: 'Delhi Technological University',
      );

      expect(notifyCount, 1);
      expect(vm.profile.programTitle, 'B.Tech Computer Science • Final Year');
      expect(vm.profile.university, 'Delhi Technological University');
      expect(vm.profile.collegeTitle, 'Delhi Technological University');

      // Verify persistent database storage
      final savedProfile = DatabaseService.instance.getProfileForUser('amirkhan@example.com');
      expect(savedProfile, isNotNull);
      expect(savedProfile!.name, 'Amir Khan');
      expect(savedProfile.degree, 'B.Tech Computer Science');
      expect(savedProfile.year, 'Final Year');
      expect(savedProfile.university, 'Delhi Technological University');
    });

    test('Updated profile details persist after logout and subsequent login', () async {
      final vm = ProfileViewModel.instance;

      // 1. Register user
      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
      );

      // 2. User edits profile details
      await vm.updateField(
        name: 'Amir Khan Updated',
        degree: 'B.Tech Computer Science',
        year: 'Final Year',
        university: 'Delhi Technological University',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      expect(vm.profile.name, 'Amir Khan Updated');

      // 3. User logs out
      await vm.logout();
      expect(DatabaseService.instance.activeUserEmail, isNull);

      // 4. User logs back in
      const authUser = AuthUser(
        id: 101,
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
      );

      await vm.onUserLoggedIn(email: 'amirkhan@example.com', authUser: authUser);

      // Verify all updated details are restored from database
      expect(vm.profile.name, 'Amir Khan Updated');
      expect(vm.profile.email, 'amirkhan@example.com');
      expect(vm.profile.phone, '+91 9876543210');
      expect(vm.profile.programTitle, 'B.Tech Computer Science • Final Year');
      expect(vm.profile.university, 'Delhi Technological University');
      expect(vm.profile.avatarUrl, 'https://example.com/avatar.jpg');
    });
  });

  group('Student Profile Screen Widget Tests', () {
    testWidgets('Profile screen dynamically displays registered name, email, phone and Add Education / Add College',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final vm = ProfileViewModel.instance;
      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(showBottomNav: false),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify registered name, email, phone are displayed
      expect(find.text('Amir Khan'), findsOneWidget);
      expect(find.text('amirkhan@example.com'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);

      // Verify "Add Field / Category" appears when missing
      expect(find.text('Add Field / Category'), findsOneWidget);
    });

    testWidgets('Editing education and college updates ProfileScreen live',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final vm = ProfileViewModel.instance;
      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(showBottomNav: false),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Programmatically update field as if edited through dialog
      await vm.updateField(
        degree: 'B.Tech Computer Science',
        year: 'Final Year',
        university: 'DTU Delhi',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('DTU Delhi'), findsOneWidget);
    });
  });

  group('Navigation Drawer Dynamic Profile Widget Tests', () {
    testWidgets('HomeDrawer displays same Name, Email, Profile details, Cohort, and navigation items',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final vm = ProfileViewModel.instance;
      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
        phone: '+91 9876543210',
      );
      await vm.updateField(
        degree: 'B.Tech Computer Science',
        year: 'Final Year',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            drawer: HomeDrawer(),
            body: Center(child: Text('Home Content')),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Open Drawer
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Name, Email, Degree in Navigation Drawer
      expect(find.text('Amir Khan'), findsOneWidget);
      expect(find.text('amirkhan@example.com'), findsOneWidget);
      expect(find.text('B.Tech Computer Science • Final Year'), findsOneWidget);

      // Verify Cohort badge
      expect(find.text('Student Cohort • 2025'), findsOneWidget);

      // Verify Drawer Menu items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Overview & feed'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Mission, team & vision'), findsOneWidget);
      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Courses & mentoring'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Bootcamps & moments'), findsOneWidget);
      expect(find.text('Contacts'), findsOneWidget);
      expect(find.text('Support & enquiries'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Preferences & security'), findsOneWidget);

      // Verify Footer
      expect(find.text('Innovate Connecta v2.4'), findsOneWidget);
      expect(find.text('MSME Reg. #UDYAM-DL-03-0012'), findsOneWidget);
    });

    testWidgets('Drawer automatically updates when profile is updated in ViewModel',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final vm = ProfileViewModel.instance;
      await vm.onUserRegistered(
        name: 'Amir Khan',
        email: 'amirkhan@example.com',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            drawer: HomeDrawer(),
            body: Center(child: Text('Home Content')),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Currently missing education
      expect(find.text('Add Education'), findsOneWidget);

      // Update profile
      await vm.updateField(
        name: 'Amir Khan Updated',
        degree: 'M.Tech AI & Data Science',
        year: '1st Year',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Drawer should immediately display updated name and degree
      expect(find.text('Amir Khan Updated'), findsOneWidget);
      expect(find.text('M.Tech AI & Data Science • 1st Year'), findsOneWidget);
    });
  });
}
