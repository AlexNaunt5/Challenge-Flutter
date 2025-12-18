import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? content;
  final String? author;
  final String? source;
  final DateTime? publishedAt;
  final String? urlToImage;
  final String? url;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final bool? isUserGenerated;
  final bool? isSaved;
  final List<String>? tags;
  final String? status;

  const ArticleEntity({
    this.id,
    this.title,
    this.description,
    this.content,
    this.author,
    this.source,
    this.publishedAt,
    this.urlToImage,
    this.url,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isUserGenerated,
    this.isSaved,
    this.tags,
    this.status,
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      content,
      author,
      source,
      publishedAt,
      urlToImage,
      url,
      category,
      createdAt,
      updatedAt,
      createdBy,
      isUserGenerated,
      isSaved,
      tags,
      status,
    ];
  }
}