import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_user_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/user_articles_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/user_articles_state.dart';

class UserArticlesBloc extends Bloc<UserArticlesEvent, UserArticlesState> {
  
  final GetUserArticlesUseCase _getUserArticlesUseCase;
  
  UserArticlesBloc(this._getUserArticlesUseCase) : super(const UserArticlesLoading()) {
    on<GetUserArticles>(_onGetUserArticles);
    on<RefreshUserArticles>(_onRefreshUserArticles);
  }

  Future<void> _onGetUserArticles(
    GetUserArticles event,
    Emitter<UserArticlesState> emit,
  ) async {
    emit(const UserArticlesLoading());
    
    final dataState = await _getUserArticlesUseCase();

    if (dataState is DataSuccess) {
      if (dataState.data!.isEmpty) {
        emit(const UserArticlesEmpty());
      } else {
        emit(UserArticlesDone(dataState.data!));
      }
    } else if (dataState is DataFailed) {
      emit(UserArticlesError(dataState.error?.message ?? 'Failed to load user articles'));
    }
  }

  Future<void> _onRefreshUserArticles(
    RefreshUserArticles event,
    Emitter<UserArticlesState> emit,
  ) async {
    add(const GetUserArticles());
  }
}
