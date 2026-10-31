import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:innovate_connecta_app/features/testimonials/models/testimonial_model.dart';
import 'package:innovate_connecta_app/features/testimonials/repository/testimonials_repository.dart';
import 'package:innovate_connecta_app/features/testimonials/view_models/testimonials_view_model.dart';
import 'package:innovate_connecta_app/features/testimonials/widgets/testimonial_card.dart';

void main() {
  const sampleJson = '''
  {
    "status": true,
    "message": "Active testimonials retrieved successfully",
    "data": [
      {
        "id": 4,
        "name": "Amir",
        "designation": "App developer",
        "review": "Awesome experience!",
        "rating": 5,
        "avatar": "testimonials/test.webp",
        "is_verified": true,
        "is_featured": false,
        "is_active": true,
        "created_at": "2026-10-22T11:51:10.000000Z",
        "updated_at": "2026-10-22T11:51:10.000000Z",
        "avatar_url": "https://awsdemo.co.in/innovateconnect/storage/testimonials/test.webp",
        "initials": "A"
      },
      {
        "id": 3,
        "name": "Md Kaif",
        "designation": "Engg",
        "review": "The service was excellent and the team was very professional.",
        "rating": 5,
        "avatar": "testimonials/test2.png",
        "is_verified": true,
        "is_featured": true,
        "is_active": true,
        "created_at": "2026-09-17T04:15:34.000000Z",
        "updated_at": "2026-09-18T04:43:40.000000Z",
        "avatar_url": "https://awsdemo.co.in/innovateconnect/storage/testimonials/test2.png",
        "initials": "MK"
      }
    ]
  }
  ''';

  group('Testimonials Model Tests', () {
    test('TestimonialModel and TestimonialsResponse deserialize properly', () {
      final jsonMap = jsonDecode(sampleJson) as Map<String, dynamic>;
      final response = TestimonialsResponse.fromJson(jsonMap);

      expect(response.status, true);
      expect(response.data.length, 2);

      final first = response.data.first;
      expect(first.id, 4);
      expect(first.name, 'Amir');
      expect(first.designation, 'App developer');
      expect(first.rating, 5.0);
      expect(first.isVerified, true);
      expect(first.initials, 'A');

      final second = response.data[1];
      expect(second.name, 'Md Kaif');
      expect(second.isFeatured, true);
      expect(second.initials, 'MK');
    });
  });

  group('Testimonials Repository & ViewModel Tests', () {
    test('Repository fetches successfully with MockClient', () async {
      final mockClient = MockClient((request) async {
        return http.Response(sampleJson, 200, headers: {'content-type': 'application/json'});
      });

      final repository = TestimonialsRepository(client: mockClient);
      final response = await repository.fetchTestimonials();

      expect(response.status, true);
      expect(response.data.length, 2);
    });

    test('ViewModel processes data, averages, and filters correctly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(sampleJson, 200, headers: {'content-type': 'application/json'});
      });

      final repository = TestimonialsRepository(client: mockClient);
      final viewModel = TestimonialsViewModel(repository: repository);

      expect(viewModel.isLoading, false);
      expect(viewModel.testimonials.isEmpty, true);

      await viewModel.fetchTestimonials();

      expect(viewModel.isLoading, false);
      expect(viewModel.allTestimonials.length, 2);
      expect(viewModel.averageRating, 5.0);
      expect(viewModel.verifiedCount, 2);

      // Filter test
      viewModel.setRatingFilter(5);
      expect(viewModel.ratingFilter, 5);
      expect(viewModel.testimonials.length, 2);

      // Toggle off filter
      viewModel.setRatingFilter(5);
      expect(viewModel.ratingFilter, 0);
    });
  });

  group('TestimonialCard Widget Test', () {
    testWidgets('TestimonialCard renders name, designation, rating, and review',
        (WidgetTester tester) async {
      const model = TestimonialModel(
        id: 1,
        name: 'Rahul Sharma',
        designation: 'Cloud Architect',
        review: 'Fantastic platform for practical exposure!',
        rating: 5,
        isVerified: true,
        isFeatured: true,
        initials: 'RS',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TestimonialCard(testimonial: model),
          ),
        ),
      );

      expect(find.text('Rahul Sharma'), findsOneWidget);
      expect(find.text('Cloud Architect'), findsOneWidget);
      expect(find.text('Fantastic platform for practical exposure!'), findsOneWidget);
      expect(find.text('FEATURED'), findsOneWidget);
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    });
  });
}
