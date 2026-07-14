import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/views/widgets/input/input_text_widget.dart';
import 'package:jiburo_app/core/views/widgets/new_scroll_bar.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_state.dart';
import 'package:jiburo_app/features/lost_post/utils/search_demo_list.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_layout.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/location_card.dart';
import 'package:jiburo_app/models/search_location_model.dart';

class AddPostSearchScreen extends ConsumerStatefulWidget {
  const AddPostSearchScreen({super.key});

  @override
  ConsumerState<AddPostSearchScreen> createState() =>
      _AddPostSearchScreenState();
}

class _AddPostSearchScreenState extends ConsumerState<AddPostSearchScreen> {
  final List<SearchLocationModel> location = SearchDemoList.location;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    print(query);
  }

  void handleSetLocation({
    required WidgetRef ref,
    required SearchLocationModel item,
  }) {
    ref
        .read(addPostProvider.notifier)
        .setLocation(
          lat: item.latitude,
          lng: item.longitude,
          address: item.foundLocation,
          locationName: item.locationName,
        );
    context.push(AppPaths.addPost);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddPostLayout(
      isSearch: true,
      contentWidget: [
        Padding(
          padding: EdgeInsets.all(16),
          child: InputTextWidget(
            placeHolder: '지역명/이름을 검색해보세요',
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) => _onSearchChanged,
            showClearButton: true,
          ),
        ),
        Expanded(
          child: NewScrollBar(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: location.length,
                itemBuilder: (context, index) {
                  return LocationCard(
                    onTap: () {
                      handleSetLocation(ref: ref, item: location[index]);
                    },
                    location: location[index],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
