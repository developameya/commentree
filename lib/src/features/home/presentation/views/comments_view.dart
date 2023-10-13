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
    final isPageRefreshed = useState<bool>(false);
    return BlocConsumer<CommentsCubit, CommentsState>(
      buildWhen: (previous, current) => previous.comments != current.comments,
      listener: (context, state) {
        switch (state.status) {
          case AppState.initial:
            isPageRefreshed.value = false;
            break;
          case AppState.loading:
            isPageRefreshed.value = state.pageNumber == 0;
            break;
          case AppState.success:
            isPageRefreshed.value = false;
            break;
          case AppState.error:
            isPageRefreshed.value = false;
            final banner = buildNoticeBanner(context, state.errorMessage);
            ScaffoldMessenger.of(context).clearMaterialBanners();
            ScaffoldMessenger.of(context).showMaterialBanner(banner);
            break;
        }
      },
      builder: (context, state) {
        return isPageRefreshed.value
            ? buildLoadingIndicator()
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      _scrollController.position.extentAfter < 5000) {
                    BlocProvider.of<CommentsCubit>(context).fetchComments();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: state.itemCount,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      index >= state.comments.length
                          ? buildLoadingIndicator()
                          : GFCard(
                              color: Theme.of(context).focusColor,
                              title: GFListTile(
                                listItemTextColor: Colors.white,
                                titleText: state.comments[index].name,
                                subTitle: Text(state.comments[index].email),
                              ),
                              content: Text(state.comments[index].body),
                            ),
                ),
              );
      },
    );
  }
}
