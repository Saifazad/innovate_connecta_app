import 'package:flutter/material.dart';
import '../models/recorded_session_model.dart';
import 'session_card.dart';

/// Horizontal Recorded Session Card delegating to unified SessionCard
class HorizontalRecordedSessionCard extends StatelessWidget {
  final RecordedSessionModel session;

  const HorizontalRecordedSessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return RecordedSessionCard(
      session: session,
      orientation: Axis.horizontal,
    );
  }
}
