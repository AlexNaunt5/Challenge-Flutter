import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository {
  // API methods
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  // Database methods
  Future<List<ArticleEntity>> getSavedArticles();

  Future<void> saveArticle(ArticleEntity article);

  Future<void> removeArticle(ArticleEntity article);

  // User-generated articles methods
  Future<DataState<void>> createArticle(ArticleEntity article);

  Future<DataState<List<ArticleEntity>>> getUserArticles();

  Future<DataState<void>> updateArticle(ArticleEntity article);

  Future<DataState<void>> deleteArticle(String articleId);
}