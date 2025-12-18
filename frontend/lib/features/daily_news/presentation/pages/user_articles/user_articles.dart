import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/user_articles_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/user_articles_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/user/user_articles_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';

class UserArticlesPage extends StatefulWidget {
  const UserArticlesPage({Key? key}) : super(key: key);

  @override
  State<UserArticlesPage> createState() => _UserArticlesPageState();
}

class _UserArticlesPageState extends State<UserArticlesPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserArticlesBloc>().add(const GetUserArticles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Articles',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocBuilder<UserArticlesBloc, UserArticlesState>(
        builder: (context, state) {
          if (state is UserArticlesLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (state is UserArticlesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserArticlesBloc>().add(const RefreshUserArticles());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is UserArticlesEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No articles yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first article to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/CreateArticle');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Article'),
                  ),
                ],
              ),
            );
          }

          if (state is UserArticlesDone) {
            return _buildArticlesList(context, state.articles ?? []);
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/CreateArticle');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context, List<ArticleEntity> articles) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserArticlesBloc>().add(const RefreshUserArticles());
      },
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ArticleWidget(
              article: articles[index],
              onArticlePressed: (article) {
                Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
              },
            ),
          );
        },
      ),
    );
  }
}
