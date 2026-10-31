import 'package:flutter/material.dart';
import '../models/recorded_session_model.dart';
import 'session_card.dart';

/// Vertical Recorded Session Card delegating to unified SessionCard
class VerticalRecordedSessionCard extends StatelessWidget {
  final RecordedSessionModel session;

  const VerticalRecordedSessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return RecordedSessionCard(
      session: session,
      orientation: Axis.vertical,
    );
  }
}
