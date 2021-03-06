import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_blocks_junior/models/content.dart';
import 'package:coding_blocks_junior/ui/widgets/Base/Thumbnail.dart';
import 'package:coding_blocks_junior/ui/widgets/Courses/ContentList/viewmodel.dart';
import 'package:coding_blocks_junior/utils/SizeConfig.dart';
import 'package:coding_blocks_junior/utils/logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContentListView extends StatelessWidget {
  final Stream<Content> contentStream;
  final Function onTap;

  ContentListView({this.contentStream, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () =>
            ContentListViewModel(contentStream: contentStream),
        builder: (context, model, child) => ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: model.contents.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ContentListItemView(
                  content: model.contents[index],
                  index: index,
                ),
                onTap: () => onTap(model.contents[index]),
              );
            }));
  }
}

class ContentListItemView extends StatelessWidget {
  final Content content;
  final int index;

  ContentListItemView({@required this.content, this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: getInsetsLTRB(30, index == 0 ? 0 : 8, 30, 8),
      child: IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(
                    width: (SizeConfig.isPortrait ? 150 : 200) *
                        SizeConfig.imageSizeMultiplier),
                child: Container(
                  margin: getInsetsLTRB(0, 0, 15, 0),
                  child: Thumbnail(url: content.url),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lecture ' + (index + 1).toString(),
                      style: theme.textTheme.bodyText2,
                    ),
                    Text(content.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: theme.textTheme.subtitle1
                            .copyWith(fontWeight: FontWeight.bold)),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat.yMMMMd('en_US')
                            .format(content.publishedAt.toDate()),
                        style: TextStyle(fontSize: 11 * SizeConfig.textMultiplier, color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
