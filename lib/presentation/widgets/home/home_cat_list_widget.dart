import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';
import 'package:catbreeds/presentation/widgets/home/index.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/presentation/screens/cat_detail_screen.dart';

/// Widget that displays the list of cat breeds on the home screen.
///
/// Manages pagination and infinite scrolling with automatic loading
/// of more breeds when reaching near the bottom of the list.
/// Features include:
/// - Listens to [BreedProvider] for state changes
/// - Implements infinite scroll with 500px threshold
/// - Delegates to state-specific widgets based on loading state
/// - Handles scroll controller lifecycle
///
/// **Example:**
/// ```dart
/// HomeCatListWidget(
///   size: MediaQuery.of(context).size,
///   breedProvider: breedProvider,
/// )
/// ```
///
/// Shows [CatListLoadingState] during initial load, [CatListErrorState]
/// on error, and [CatListViewWidget] when data is available.
class HomeCatListWidget extends StatefulWidget {
  /// The parent widget's size for card sizing calculations.
  ///
  /// Used to determine responsive card dimensions that adapt to
  /// different screen sizes and orientations.
  final Size size;

  /// The [BreedProvider] instance for managing breed list state.
  ///
  /// Provides access to the list of breeds, loading states, pagination
  /// information, and error handling for the list view.
  final BreedProvider breedProvider;

  /// Creates a [HomeCatListWidget] that displays a paginated list of breeds.
  ///
  /// Both [size] and [breedProvider] are required. The [size] should typically
  /// be obtained from `MediaQuery.of(context).size` for responsive layout.
  ///
  /// This widget manages its own scroll listener and provider subscription
  /// to handle infinite scrolling and state updates.
  const HomeCatListWidget({
    super.key,
    required this.size,
    required this.breedProvider,
  });

  @override
  State<HomeCatListWidget> createState() => _HomeCatListWidgetState();
}

class _HomeCatListWidgetState extends State<HomeCatListWidget> {
  late ScrollController _scrollController;
  late VoidCallback _providerListener;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollListener);
    _providerListener = () {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    };
    widget.breedProvider.addListener(_providerListener);
  }

  void _onScrollListener() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        !widget.breedProvider.isLoading &&
        !widget.breedProvider.hasReachedMax &&
        widget.breedProvider.breeds.isNotEmpty) {
      widget.breedProvider.loadMoreBreeds();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.breedProvider.removeListener(_providerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.breedProvider.hasError) {
      return CatListErrorState(size: widget.size);
    }

    if (widget.breedProvider.breeds.isEmpty && widget.breedProvider.isLoading) {
      return const CatListLoadingState();
    }

    return CatListViewWidget(
      size: widget.size,
      breedProvider: widget.breedProvider,
      scrollController: _scrollController,
    );
  }
}

// ==================== STATE WIDGETS ====================

/// Widget displayed when an error occurs loading the cat breeds list.
///
/// Shows a centered offline icon to indicate connection or loading failure.
/// Uses responsive sizing to maintain visual consistency across devices.
class CatListErrorState extends StatelessWidget {
  /// The parent widget's size for responsive icon sizing.
  ///
  /// The icon size is calculated as 40% of the screen width.
  final Size size;

  /// Creates a [CatListErrorState] widget for error display.
  ///
  /// The [size] parameter is required for responsive icon sizing.
  const CatListErrorState({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.wifi_off_outlined,
        color: Colors.grey[400],
        size: size.width * 0.4,
      ),
    );
  }
}

/// Widget displayed while loading the cat breeds list.
///
/// Shows a centered circular progress indicator during initial load
/// and when loading additional items during infinite scroll.
class CatListLoadingState extends StatelessWidget {
  /// Creates a [CatListLoadingState] widget for loading display.
  const CatListLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryGreenColor,
      ),
    );
  }
}

/// Widget that renders the actual list of cat breed cards.
///
/// Displays breeds in a scrollable list with:
/// - Responsive card sizing based on screen height
/// - Image backgrounds with breed information overlay
/// - Hero animations for smooth detail screen transitions
/// - Loading indicator at the bottom during pagination
/// - Infinite scroll with automatic pagination
///
/// **Features:**
/// - Navigates to [CatDetailScreen] on breed tap
/// - Shows energy level, affection level, and intelligence indicators
/// - Handles breed images with fallback assets
/// - Bouncing scroll physics for iOS-like feel
class CatListViewWidget extends StatelessWidget {
  /// The parent widget's size for card sizing calculations.
  ///
  /// Used in responsive height calculation for list cards.
  final Size size;

  /// The [BreedProvider] instance containing the breed list and state.
  ///
  /// Provides access to the list of breeds, loading state, error state,
  /// and pagination information.
  final BreedProvider breedProvider;

  /// The [ScrollController] for managing scroll events.
  ///
  /// Controlled by the parent [_HomeCatListWidgetState] to implement
  /// infinite scroll pagination detection.
  final ScrollController scrollController;

  /// Creates a [CatListViewWidget] that renders a paginated breed list.
  ///
  /// All parameters are required:
  /// - [size]: Parent widget size from `MediaQuery.of(context).size`
  /// - [breedProvider]: State management for breeds and pagination
  /// - [scrollController]: Controller managed by parent state for infinite scroll
  const CatListViewWidget({
    super.key,
    required this.size,
    required this.breedProvider,
    required this.scrollController,
  });

  double _normalizeValue(int value) {
    return (value / 5).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // Responsive height calculation
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = (screenHeight * 0.48).clamp(280.0, 380.0);

    return ListView.builder(
        controller: scrollController,
        itemCount:
            breedProvider.breeds.length + (breedProvider.hasReachedMax ? 0 : 1),
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        itemBuilder: (context, index) {
          if (index >= breedProvider.breeds.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CatListLoadingState(),
              ),
            );
          }

          final catInfo = breedProvider.breeds[index];
          return SizedBox(
            height: cardHeight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FadeTransition(
                              opacity: animation,
                              child: CatDetailScreen(catInfo: catInfo))),
                );
              },
              child: Hero(
                tag: 'cat_image_${catInfo.id}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: catInfo.image != null
                            ? NetworkImage(catInfo.image!.url)
                            : const AssetImage('assets/images/cat.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black45,
                          BlendMode.darken,
                        ),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        // Contenido principal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  child: Text(catInfo.name),
                                ),
                                const SizedBox(height: 5.0),
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.0,
                                  ),
                                  child: Text(catInfo.origin),
                                ),
                                const SizedBox(height: 12.0),
                                // Indicadores visuales sutiles
                                Row(
                                  children: [
                                    HomeBarIndicatorWidget(
                                      value:
                                          _normalizeValue(catInfo.energyLevel),
                                    ),
                                    const SizedBox(width: 8.0),
                                    HomeBarIndicatorWidget(
                                      value: _normalizeValue(
                                          catInfo.affectionLevel),
                                    ),
                                    const SizedBox(width: 8.0),
                                    HomeBarIndicatorWidget(
                                      value:
                                          _normalizeValue(catInfo.intelligence),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
