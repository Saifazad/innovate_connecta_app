import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/sessions_view_model.dart';
import '../widgets/session_header.dart';
import '../widgets/vertical_live_session_card.dart';
import '../../../shared/widgets/widgets.dart';

class AllLiveSessionsScreen extends StatefulWidget {
  final SessionsViewModel? viewModel;

  const AllLiveSessionsScreen({super.key, this.viewModel});

  @override
  State<AllLiveSessionsScreen> createState() => _AllLiveSessionsScreenState();
}

class _AllLiveSessionsScreenState extends State<AllLiveSessionsScreen> {
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
      if (_viewModel.liveSessions.isEmpty && !_viewModel.isLoadingLive) {
        _viewModel.fetchLiveSessions();
      }
    } else {
      _viewModel = SessionsViewModel();
      _ownsViewModel = true;
      _viewModel.fetchLiveSessions();
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
    final liveSessions = _viewModel.filteredLiveSessions;
    final categories = _viewModel.liveCategories;

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
                title: 'All Live Sessions',
                subtitle: 'Masterclasses, live workshops & recordings',
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
                    final isSelected = cat == _viewModel.selectedLiveCategory;

                    return FilterTabChip(
                      label: cat,
                      isSelected: isSelected,
                      activeColor: activePurple,
                      inactiveBgColor: chipBg,
                      inactiveBorderColor: chipBorder,
                      onTap: () => _viewModel.setLiveCategory(cat),
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
                  onRefresh: () => _viewModel.fetchLiveSessions(),
                  child: _viewModel.isLoadingLive && liveSessions.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: activePurple),
                        )
                      : liveSessions.isEmpty
                          ? Center(
                              child: Text(
                                'No live sessions found in this category',
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount: liveSessions.length,
                              separatorBuilder: (context, _) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return VerticalLiveSessionCard(
                                  session: liveSessions[index],
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
