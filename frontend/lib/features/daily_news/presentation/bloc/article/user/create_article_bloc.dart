import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/create_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/create_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/create_article_state.dart';

class CreateArticleBloc extends Bloc<CreateArticleEvent, CreateArticleState> {
  
  final CreateArticleUseCase _createArticleUseCase;
  
  CreateArticleBloc(this._createArticleUseCase) : super(const CreateArticleInitial()) {
    on<CreateArticleRequested>(_onCreateArticleRequested);
    on<ResetCreateArticleState>(_onResetState);
  }

  Future<void> _onCreateArticleRequested(
    CreateArticleRequested event,
    Emitter<CreateArticleState> emit,
  ) async {
    emit(const CreateArticleLoading());
    
    final dataState = await _createArticleUseCase(params: event.article);

    if (dataState is DataSuccess) {
      emit(CreateArticleSuccess(event.article));
    } else if (dataState is DataFailed) {
      emit(CreateArticleError(dataState.error?.message ?? 'Failed to create article'));
    }
  }

  Future<void> _onResetState(
    ResetCreateArticleState event,
    Emitter<CreateArticleState> emit,
  ) async {
    emit(const CreateArticleInitial());
  }
}
