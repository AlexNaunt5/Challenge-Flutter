import 'package:equatable/equatable.dart';

abstract class UserArticlesEvent extends Equatable {
  const UserArticlesEvent();
  
  @override
  List<Object?> get props => [];
}

class GetUserArticles extends UserArticlesEvent {
  const GetUserArticles();
}

class RefreshUserArticles extends UserArticlesEvent {
  const RefreshUserArticles();
}
