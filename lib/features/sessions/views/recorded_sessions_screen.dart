import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/sessions_view_model.dart';
import '../widgets/session_header.dart';
import '../widgets/vertical_recorded_session_card.dart';
import '../../../shared/widgets/widgets.dart';

class RecordedSessionsScreen extends StatefulWidget {
  final SessionsViewModel? viewModel;

  const RecordedSessionsScreen({super.key, this.viewModel});

  @override
  State<RecordedSessionsScreen> createState() => _RecordedSessionsScreenState();
}

class _RecordedSessionsScreenState extends State<RecordedSessionsScreen> {
  late final SessionsViewModel _viewModel;
  bool _ownsViewModel = false;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color activePurple = Color(0xFF7C3AED);
  static const Color chipBorder = Color(0xFF1E293B);
  static const Color chipBg = Color(0xFF131B2E);

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
      if (_viewModel.recordedSessions.isEmpty &&
          !_viewModel.isLoadingRecorded) {
        _viewModel.fetchRecordedSessions();
      }
      if (_viewModel.recordedCategoryModels.isEmpty &&
          !_viewModel.isLoadingCategories) {
        _viewModel.fetchRecordedCategories();
      }
    } else {
      _viewModel = SessionsViewModel();
      _ownsViewModel = true;
      _viewModel.fetchRecordedSessions();
      _viewModel.fetchRecordedCategories();
    }
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recordedSessions = _viewModel.filteredRecordedSessions;
    final categories = _viewModel.recordedCategoryList;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: darkCanvas,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: darkCanvas,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              SessionHeader(
                title: 'Recorded Sessions',
                subtitle:
                    'Our digital learning library allows learners to purchase recorded sessions and access them anytime after payment.',
                onBack: () => Navigator.of(context).pop(),
              ),

              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  separatorBuilder: (context, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected =
                        cat.id == _viewModel.selectedRecordedCategoryId ||
                        (cat.id == 0 &&
                            _viewModel.selectedRecordedCategory ==
                                'All Library');

                    return FilterTabChip(
                      label: cat.name,
                      isSelected: isSelected,
                      activeColor: activePurple,
                      inactiveBgColor: chipBg,
                      inactiveBorderColor: chipBorder,
                      onTap: () => _viewModel.selectRecordedCategory(cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // Content List
              Expanded(
                child: RefreshIndicator(
                  color: activePurple,
                  backgroundColor: chipBg,
                  onRefresh: () => Future.wait([
                    _viewModel.fetchRecordedSessions(),
                    _viewModel.fetchRecordedCategories(),
                  ]),
                  child:
                      _viewModel.isLoadingRecorded && recordedSessions.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: activePurple),
                        )
                      : _viewModel.recordedError != null &&
                            recordedSessions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cloud_off_rounded,
                                  size: 44,
                                  color: Color(0xFFEF4444),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _viewModel.recordedError!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => Future.wait([
                                    _viewModel.fetchRecordedSessions(),
                                    _viewModel.fetchRecordedCategories(),
                                  ]),
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Retry',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: activePurple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : recordedSessions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No recorded sessions found in this category',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: recordedSessions.length,
                          separatorBuilder: (context, _) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return VerticalRecordedSessionCard(
                              session: recordedSessions[index],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
