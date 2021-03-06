import 'package:coding_blocks_junior/dao/base.dart';
import 'package:coding_blocks_junior/models/progress.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProgressDao extends BaseDao<Progress> {
  @Query('SELECT * FROM Progress')
  Future<List<Progress>> findAllProgress();

  @Query('SELECT COUNT(*) FROM Progress WHERE courseId=:courseId')
  Future<List<Progress>> findCourseProgress(String courseId);
}