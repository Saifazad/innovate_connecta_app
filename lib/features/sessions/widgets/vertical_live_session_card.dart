import 'package:flutter/material.dart';
import '../models/live_session_model.dart';
import 'session_card.dart';

/// Vertical Live Session Card delegating to unified SessionCard
class VerticalLiveSessionCard extends StatelessWidget {
  final LiveSessionModel session;

  const VerticalLiveSessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return LiveSessionCard(
      session: session,
      orientation: Axis.vertical,
    );
  }
}
