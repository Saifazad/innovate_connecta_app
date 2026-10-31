import 'package:flutter/material.dart';
import '../models/live_session_model.dart';
import 'session_card.dart';

/// Horizontal Live Session Card delegating to unified SessionCard
class HorizontalLiveSessionCard extends StatelessWidget {
  final LiveSessionModel session;

  const HorizontalLiveSessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return LiveSessionCard(
      session: session,
      orientation: Axis.horizontal,
    );
  }
}
