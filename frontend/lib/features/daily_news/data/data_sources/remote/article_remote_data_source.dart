import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getArticles();
  
  Future<List<ArticleModel>> getUserArticles(String userId);
  
  Future<void> createArticle(ArticleModel article);
  
  Future<void> updateArticle(ArticleModel article);
  
  Future<void> deleteArticle(String articleId);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final FirebaseFirestore _firestore;

  ArticleRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<ArticleModel>> getArticles() async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('status', isEqualTo: 'published')
          .orderBy('publishedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => ArticleModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  @override
  Future<List<ArticleModel>> getUserArticles(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ArticleModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user articles: $e');
    }
  }

  @override
  Future<void> createArticle(ArticleModel article) async {
    try {
      await _firestore
          .collection('articles')
          .doc(article.id)
          .set({
        'id': article.id,
        'title': article.title,
        'description': article.description,
        'content': article.content,
        'author': article.author,
        'source': article.source,
        'publishedAt': article.publishedAt?.toIso8601String(),
        'urlToImage': article.urlToImage,
        'url': article.url,
        'category': article.category,
        'createdAt': article.createdAt?.toIso8601String(),
        'updatedAt': article.updatedAt?.toIso8601String(),
        'createdBy': article.createdBy,
        'isUserGenerated': article.isUserGenerated,
        'isSaved': article.isSaved,
        'tags': article.tags,
        'status': article.status,
      });
    } catch (e) {
      throw Exception('Failed to create article: $e');
    }
  }

  @override
  Future<void> updateArticle(ArticleModel article) async {
    try {
      await _firestore
          .collection('articles')
          .doc(article.id)
          .update({
        'title': article.title,
        'description': article.description,
        'content': article.content,
        'author': article.author,
        'updatedAt': article.updatedAt?.toIso8601String(),
        'tags': article.tags,
        'status': article.status,
      });
    } catch (e) {
      throw Exception('Failed to update article: $e');
    }
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    try {
      await _firestore.collection('articles').doc(articleId).delete();
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }
}
