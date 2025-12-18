import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/article_remote_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final ArticleRemoteDataSource? _articleRemoteDataSource;
  
  ArticleRepositoryImpl(
    this._newsApiService, [
    this._articleRemoteDataSource,
  ]);
  
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioError(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
            type: DioErrorType.response,
            error: httpResponse.response.statusMessage,
          )
        );
      }
    } on DioError catch(e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    // TODO: Implement local database storage
    return [];
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    // TODO: Implement local database removal
    return;
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    // TODO: Implement local database save
    return;
  }

  @override
  Future<DataState<void>> createArticle(ArticleEntity article) async {
    try {
      if (_articleRemoteDataSource != null) {
        // Use Firestore if available
        await _articleRemoteDataSource!.createArticle(ArticleModel.fromEntity(article));
      }
      return const DataSuccess(null);
    } catch(e) {
      return DataFailed(DioError(
        error: e.toString(),
        type: DioErrorType.other,
        requestOptions: RequestOptions(path: ''),
      ));
    }
  }

  @override
  Future<DataState<List<ArticleEntity>>> getUserArticles() async {
    try {
      if (_articleRemoteDataSource != null) {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          // Fetch from Firestore
          final articles = await _articleRemoteDataSource!.getUserArticles(currentUser.uid);
          return DataSuccess(articles);
        }
      }
      return const DataSuccess([]);
    } catch(e) {
      return DataFailed(DioError(
        error: e.toString(),
        type: DioErrorType.other,
        requestOptions: RequestOptions(path: ''),
      ));
    }
  }

  @override
  Future<DataState<void>> updateArticle(ArticleEntity article) async {
    try {
      if (_articleRemoteDataSource != null) {
        await _articleRemoteDataSource!.updateArticle(ArticleModel.fromEntity(article));
      }
      return const DataSuccess(null);
    } catch(e) {
      return DataFailed(DioError(
        error: e.toString(),
        type: DioErrorType.other,
        requestOptions: RequestOptions(path: ''),
      ));
    }
  }

  @override
  Future<DataState<void>> deleteArticle(String articleId) async {
    try {
      if (_articleRemoteDataSource != null) {
        await _articleRemoteDataSource!.deleteArticle(articleId);
      }
      return const DataSuccess(null);
    } catch(e) {
      return DataFailed(DioError(
        error: e.toString(),
        type: DioErrorType.other,
        requestOptions: RequestOptions(path: ''),
      ));
    }
  }
  
}
