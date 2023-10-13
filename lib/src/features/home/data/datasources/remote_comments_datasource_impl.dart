import 'dart:convert';

import 'package:commentree/src/core/common/constants/constants.dart';
import 'package:commentree/src/core/utils/error/failures.dart';
import 'package:commentree/src/features/home/data/datasources/comments_datasource.dart';
import 'package:commentree/src/features/home/data/models/comment_model.dart';
import 'package:commentree/src/features/home/domain/entities/comment_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

///Implementation of [CommentsDatasource] for remote data.
///
@Named(remoteDatsourceKey)
@LazySingleton(as: CommentsDatasource)
class RemoteCommentsDatasourceImpl extends CommentsDatasource {
  final Dio _dio;

  RemoteCommentsDatasourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, List<CommentEntity>>> fetchComments(
      {required int count, required int page}) async {
    try {
      final Response<String> response = await _dio.get(
          'https://jsonplaceholder.typicode.com/comments',
          queryParameters: {
            '_page': page.toString(),
            'limit': count.toString(),
          });

      if (response.statusCode == 200) {
        try {
          if (response.data == null) {
            return Future.value(left(const ServerFailure(
                message: 'Error occured while decoding the data.')));
          }
          final List data = json.decode(response.data!);

          final List<CommentEntity> results =
              data.map((element) => CommentModel.fromJson(element)).toList();

          return Future.value(right(results));
        } on FormatException catch (error) {
          return Future.value(left(ServerFailure(
              message: 'error while fetching data: ${error.message}')));
        }
      } else {
        return Future.value(left(ServerFailure(
          message:
              'error while fetching data: ${response.statusCode} - ${response.statusMessage}',
        )));
      }
    } on DioException catch (error) {
      return Future.value(left(ServerFailure(message: error.message)));
    }
  }
}
