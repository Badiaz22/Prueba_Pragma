import 'package:flutter/material.dart';
import 'package:catbreeds/utils/colors.dart';
import 'package:catbreeds/domain/entities/entities.dart';
import 'package:catbreeds/presentation/widgets/detail/index.dart';

class CatDetailScreen extends StatelessWidget {
  final BreedEntity? catInfo;

  const CatDetailScreen({super.key, this.catInfo});

  @override
  Widget build(BuildContext context) {
    if (catInfo == null) {
      return Scaffold(
        backgroundColor: AppColors.whiteBackgroundColor,
        appBar: AppBar(
          title: const Text('Cat Detail'),
          backgroundColor: AppColors.whiteBackgroundColor,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: const Center(
          child: Text('No information available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HeaderDelegate(catInfo: catInfo!),
          ),
          SliverToBoxAdapter(
            child: CatBasicInfoWidget(catInfo: catInfo!),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CatDescriptionWidget(description: catInfo!.description),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: CatTemperamentWidget(temperament: catInfo!.temperament),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
              child: CatAttributesWidget(catInfo: catInfo!),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final BreedEntity catInfo;

  _HeaderDelegate({required this.catInfo});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        CatDetailHeaderWidget(catInfo: catInfo),
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            color: AppColors.whiteBackgroundColor,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 300.0;

  @override
  double get minExtent => 300.0;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) {
    return oldDelegate.catInfo != catInfo;
  }
}
