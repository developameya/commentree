import 'package:auto_route/auto_route.dart';
import 'package:commentree/src/core/common/routing/app_router.dart';
import 'package:commentree/src/core/common/widgets/banner_widget.dart';
import 'package:commentree/src/core/utils/state/app_state.dart';
import 'package:commentree/src/features/home/presentation/state/comments_cubit.dart';
import 'package:commentree/src/features/home/presentation/state/comments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:getwidget/getwidget.dart';

class CommentsView extends HookWidget {
  const CommentsView({super.key});

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
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: state.comments.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context.router.push(const CommentRoute()),
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
              );
      },
    );
  }
}
