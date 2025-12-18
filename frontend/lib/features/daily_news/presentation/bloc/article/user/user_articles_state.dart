import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class UserArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final String? error;
  
  const UserArticlesState({this.articles, this.error});
  
  @override
  List<Object?> get props => [articles, error];
}

class UserArticlesLoading extends UserArticlesState {
  const UserArticlesLoading();
}

class UserArticlesDone extends UserArticlesState {
  const UserArticlesDone(List<ArticleEntity> articles) : super(articles: articles);
}

class UserArticlesError extends UserArticlesState {
  const UserArticlesError(String error) : super(error: error);
}

class UserArticlesEmpty extends UserArticlesState {
  const UserArticlesEmpty();
}
