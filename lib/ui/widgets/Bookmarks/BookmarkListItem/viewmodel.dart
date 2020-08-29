import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_blocks_junior/app/locator.dart';
import 'package:coding_blocks_junior/app/router.gr.dart';
import 'package:coding_blocks_junior/models/bookmark.dart';
import 'package:coding_blocks_junior/models/content.dart';
import 'package:coding_blocks_junior/models/course.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookmarkListItemViewModel extends FutureViewModel<void> {
  NavigationService _navigationService = locator<NavigationService>();
  final Bookmark bookmark;
  Course course;
  Content content;

  BookmarkListItemViewModel({
    @required this.bookmark
  });

  @override
  Future<void> futureToRun() {
    return loadContentAndCourse();
  }

  Future loadContentAndCourse() async {
    final String courseId = bookmark.courseId;
    final String contentId = bookmark.contentId;

    var courseDoc = await Firestore
      .instance
      .collection('courses')
      .document(courseId).get();

    course = Course.fromSnapshot(courseDoc);

    var contentDoc = await Firestore.instance
        .collection('contents')
        .document(contentId).get();

    content = Content.fromSnapshot(contentDoc);
  }

  void goToContent () {
    _navigationService.navigateTo(Routes.playerView(
        courseId: bookmark.courseId,
        contentId: bookmark.contentId
    ));
  }
}