import 'package:floor/floor.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import '../../../../core/constants/constants.dart';

@Entity(tableName: 'article', primaryKeys: ['id'])
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    String? id,
    String? title,
    String? description,
    String? content,
    String? author,
    String? source,
    DateTime? publishedAt,
    String? urlToImage,
    String? url,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isUserGenerated,
    bool? isSaved,
    List<String>? tags,
    String? status,
  }) : super(
    id: id,
    title: title,
    description: description,
    content: content,
    author: author,
    source: source,
    publishedAt: publishedAt,
    urlToImage: urlToImage,
    url: url,
    category: category,
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
    isUserGenerated: isUserGenerated,
    isSaved: isSaved,
    tags: tags,
    status: status,
  );

  factory ArticleModel.fromJson(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] ?? "",
      author: map['author'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      url: map['url'] ?? "",
      urlToImage: map['urlToImage'] != null && map['urlToImage'] != "" 
        ? map['urlToImage'] 
        : kDefaultImage,
      publishedAt: map['publishedAt'] != null 
        ? DateTime.tryParse(map['publishedAt']) 
        : null,
      content: map['content'] ?? "",
      source: map['source'] ?? "NewsAPI",
      category: map['category'],
      createdAt: map['createdAt'] != null 
        ? DateTime.tryParse(map['createdAt']) 
        : null,
      updatedAt: map['updatedAt'] != null 
        ? DateTime.tryParse(map['updatedAt']) 
        : null,
      createdBy: map['createdBy'],
      isUserGenerated: map['isUserGenerated'] ?? false,
      isSaved: map['isSaved'] ?? false,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      status: map['status'] ?? "published",
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
      source: entity.source,
      category: entity.category,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      isUserGenerated: entity.isUserGenerated,
      isSaved: entity.isSaved,
      tags: entity.tags,
      status: entity.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
      'source': source,
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'isUserGenerated': isUserGenerated,
      'isSaved': isSaved,
      'tags': tags,
      'status': status,
    };
  }
}
}