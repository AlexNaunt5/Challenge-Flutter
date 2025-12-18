import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class CreateArticleEvent extends Equatable {
  const CreateArticleEvent();
  
  @override
  List<Object?> get props => [];
}

class CreateArticleRequested extends CreateArticleEvent {
  final ArticleEntity article;
  
  const CreateArticleRequested(this.article);
  
  @override
  List<Object?> get props => [article];
}

class ResetCreateArticleState extends CreateArticleEvent {
  const ResetCreateArticleState();
}
