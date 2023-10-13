import 'package:auto_route/auto_route.dart';
import 'package:commentree/src/core/common/routing/app_router.dart';
import 'package:commentree/src/core/common/widgets/banner_widget.dart';
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/features/home/presentation/state/comments_cubit.dart';
import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:commentree/src/features/home/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:getwidget/getwidget.dart';

//if only 3 posts remain out of sight, fetch new posts
class CommentsView extends HookWidget {
  ///Provides information with regards to scroll position of the
  ///list.
  final ScrollController _scrollController;

  ///Creates comment view.
  CommentsView({super.key}) : _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    return BlocConsumer<CommentsCubit, CommentsState>(
      listener: (context, state) {
        switch (state.status) {
          case AppState.initial:
            break;
          case AppState.loading:
            isLoading.value = true;
            break;
          case AppState.success:
            isLoading.value = false;
            break;
          case AppState.error:
            isLoading.value = false;
            final banner = buildNoticeBanner(context, state.errorMessage);
            ScaffoldMessenger.of(context).clearMaterialBanners();
            ScaffoldMessenger.of(context).showMaterialBanner(banner);
            break;
        }
      },
      builder: (context, state) {
        return isLoading.value
            ? buildLoadingIndicator()
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      _scrollController.position.extentAfter == 0) {
                    BlocProvider.of<CommentsCubit>(context).fetchComments();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: state.itemCount,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      //if the current index is greater than the length of list
                      //of comments, display a loading indicator at current index.
                      index >= state.comments.length
                          ? buildLoadingIndicator()
                          : GestureDetector(
                              onTap: () =>
                                  context.router.push(const CommentRoute()),
                              child: GFCard(
                                color: Theme.of(context).focusColor,
                                title: GFListTile(
                                  listItemTextColor: Colors.white,
                                  titleText: state.comments[index].name,
                                  subTitle: Text(state.comments[index].email),
                                ),
                                content: Text(state.comments[index].body),
                              ),
                            ),
                ),
              );
      },
    );
  }
}
