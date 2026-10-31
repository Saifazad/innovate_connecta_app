import 'package:flutter_test/flutter_test.dart';
import 'package:innovate_connecta_app/features/sessions/models/live_session_model.dart';
import 'package:innovate_connecta_app/features/sessions/models/recorded_session_model.dart';
import 'package:innovate_connecta_app/features/sessions/models/session_category_model.dart';
import 'package:innovate_connecta_app/features/sessions/view_models/sessions_view_model.dart';

void main() {
  group('Sessions Model & Serialization Tests', () {
    test('LiveSessionModel parses JSON correctly', () {
      final json = {
        'id': 8,
        'title': 'Master class on Python full stack',
        'slug': 'master-class-on-python-full-stack',
        'session_category_id': 14,
        'short_description': 'master class on python full stack development',
        'quick_summary': {
          'session_title': 'Master class on Python full stack',
          'session_date': null,
          'date_and_time': '2 Hours',
          'participation_fee': {
            'label': 'Participation Fee',
            'price': '₹19',
            'original_price': '₹99'
          }
        },
        'category': {
          'id': 14,
          'name': 'Web Development',
          'slug': 'web-development'
        }
      };

      final session = LiveSessionModel.fromJson(json);
      expect(session.id, 8);
      expect(session.title, 'Master class on Python full stack');
      expect(session.categoryName, 'Web Development');
      expect(session.fee, '₹19');
      expect(session.originalFee, '₹99');
      expect(session.date, '2 Hours');
    });

    test('RecordedSessionModel parses JSON correctly', () {
      final json = {
        'id': 12,
        'session_category_id': 15,
        'title': 'System Design & Scalable Architecture',
        'heading': 'Learn to design scalable software systems.',
        'duration': '14 Hours',
        'lessons': '18 Lessons',
        'original_price': '4999',
        'discount_price': '3999',
        'formatted_original_price': '₹4,999',
        'formatted_discount_price': '₹3,999',
        'category': {
          'id': 15,
          'name': 'System Design',
          'slug': 'system-design'
        }
      };

      final session = RecordedSessionModel.fromJson(json);
      expect(session.id, 12);
      expect(session.categoryId, 15);
      expect(session.title, 'System Design & Scalable Architecture');
      expect(session.categoryName, 'System Design');
      expect(session.duration, '14 Hours');
      expect(session.lessons, '18 Lessons');
      expect(session.discountPrice, '₹3,999');
      expect(session.originalPrice, '₹4,999');
      expect(session.leftBadge, 'CI / CD');
      expect(session.rightBadge, 'DATABASE');
    });

    test('RecordedSessionModel.fromSessionJson parses session JSON correctly', () {
      final json = {
        'id': 8,
        'title': 'Master class on Python full stack',
        'session_category_id': 14,
        'short_description': 'Python full stack development',
        'category': {
          'id': 14,
          'name': 'Web Development',
          'type': 'recorded'
        },
        'info_cards': [
          {'title': 'Participation Fee', 'price': '₹19', 'original_price': '₹99'},
          {'title': 'Duration', 'description': '2 Hours'}
        ]
      };

      final session = RecordedSessionModel.fromSessionJson(json);
      expect(session.id, 8);
      expect(session.categoryId, 14);
      expect(session.title, 'Master class on Python full stack');
      expect(session.categoryName, 'Web Development');
      expect(session.discountPrice, '₹19');
      expect(session.duration, '2 Hours');
    });

    test('SessionCategoryModel parses JSON correctly', () {
      final json = {
        'id': 15,
        'name': 'System Design',
        'slug': 'system-design',
        'type': 'recorded',
        'color': 'orange',
        'is_active': true,
        'sessions_count': 1,
      };

      final category = SessionCategoryModel.fromJson(json);
      expect(category.id, 15);
      expect(category.name, 'System Design');
      expect(category.slug, 'system-design');
      expect(category.type, 'recorded');
      expect(category.isActive, true);
    });
  });

  group('SessionsViewModel Filtering Tests', () {
    test('Filtering live sessions by category works', () {
      final viewModel = SessionsViewModel();
      expect(viewModel.selectedLiveCategory, 'All Sessions');
      viewModel.setLiveCategory('System Design');
      expect(viewModel.selectedLiveCategory, 'System Design');
      viewModel.setLiveCategory('All Sessions');
      expect(viewModel.selectedLiveCategory, 'All Sessions');
    });

    test('Filtering recorded sessions by category works', () {
      final viewModel = SessionsViewModel();
      expect(viewModel.selectedRecordedCategory, 'All Library');
      expect(viewModel.selectedRecordedCategoryId, 0);

      viewModel.selectRecordedCategory(
        const SessionCategoryModel(id: 15, name: 'System Design', slug: 'system-design'),
      );
      expect(viewModel.selectedRecordedCategory, 'System Design');
      expect(viewModel.selectedRecordedCategoryId, 15);

      viewModel.selectRecordedCategory(
        const SessionCategoryModel(id: 0, name: 'All Library', slug: 'all-library'),
      );
      expect(viewModel.selectedRecordedCategory, 'All Library');
      expect(viewModel.selectedRecordedCategoryId, 0);
    });
  });
}
