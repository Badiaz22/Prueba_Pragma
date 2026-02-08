import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:catbreeds/utils/colors.dart';
import 'package:catbreeds/presentation/widgets/home/index.dart';
import 'package:catbreeds/presentation/providers/breed_provider.dart';
import 'package:catbreeds/presentation/delegates/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  final BreedProvider breedProvider;

  const HomeScreen({super.key, required this.breedProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load breeds after first frame is rendered to avoid blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.breedProvider.breeds.isEmpty &&
          !widget.breedProvider.isLoading) {
        widget.breedProvider.fetchBreeds();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      widget.breedProvider.loadMoreBreeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Catbreeds',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreenColor,
          ),
        ),
        backgroundColor: AppColors.whiteBackgroundColor,
        leading: IconButton(
            color: AppColors.primaryGreenColor,
            onPressed: () => showSearch(
                  context: context,
                  delegate:
                      BreedSearchDelegate(breedProvider: widget.breedProvider),
                ),
            icon: const Icon(CupertinoIcons.search)),
        elevation: 0,
      ),
      body: HomeCatListWidget(size: size, breedProvider: widget.breedProvider),
    );
  }
}
