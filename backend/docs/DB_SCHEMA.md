# Firestore Database Schema Documentation

## Overview
This document describes the Firestore database schema for the Applicant Showcase App. The app supports two types of articles: those from the NewsAPI (read-only) and user-generated articles (uploaded by journalists).

## Collections

### 1. **articles** (Main Collection)
Stores all articles in the application, both from the API and user-generated content.

#### Document Structure
```
articles/{articleId}
├── id (string) - Unique identifier for the article
├── title (string) - Article headline
├── description (string) - Short summary of the article
├── content (string) - Full article content
├── author (string) - Author name
├── source (string) - Source of the article (e.g., "NewsAPI", "User-Generated")
├── publishedAt (timestamp) - Publication date and time
├── urlToImage (string) - URL to article thumbnail image in Cloud Storage (media/articles/)
├── url (string) - Original article URL (if from external source)
├── category (string) - Article category (e.g., "technology", "business", "health")
├── createdAt (timestamp) - When the article was added to Firestore
├── updatedAt (timestamp) - Last modification timestamp
├── createdBy (string) - UID of user who created/uploaded the article
├── isUserGenerated (boolean) - Flag indicating if article was uploaded by a user
├── isSaved (boolean) - Global flag for article popularity/saved count
├── tags (array<string>) - Array of tags for search and categorization
└── status (string) - Document status ("published", "draft", "archived")
```

#### Security Rules Applied
- Only authenticated users can read articles
- Only authenticated users can create articles
- Users can only edit their own articles
- Admin users can delete any article
- Automatic timestamps for audit trail

---

### 2. **userArticles** (Subcollection)
Stores user-specific article interactions and drafts.

**Location:** `articles/{articleId}/userArticles/{userId}`

#### Document Structure
```
articles/{articleId}/userArticles/{userId}
├── userId (string) - Reference to the user
├── savedAt (timestamp) - When user saved the article
├── lastReadAt (timestamp) - When user last read the article
├── readCount (number) - Number of times user has read this article
└── personalNotes (string) - Optional user notes about the article
```

---

### 3. **userProfiles** (Main Collection - Optional for Future Enhancement)
Stores user profile information for article authors.

#### Document Structure
```
userProfiles/{userId}
├── userId (string) - Firebase Authentication UID
├── displayName (string) - User's display name
├── email (string) - User's email address
├── profileImageUrl (string) - URL to user profile image in Cloud Storage
├── bio (string) - Short biography
├── joinedAt (timestamp) - Account creation date
├── articlesPublished (number) - Count of published articles
└── followersCount (number) - Number of followers
```

---

## Cloud Storage Structure

### Folder Hierarchy
```
storage/
└── media/
    └── articles/
        ├── {articleId}_thumbnail.{ext}
        └── {articleId}_content_image.{ext}
```

### File Naming Convention
- Thumbnails: `{articleId}_thumbnail.jpg`
- Content images: `{articleId}_image_{sequence}.jpg`
- Max file size: 10MB per image
- Supported formats: JPG, PNG, WebP

### Security Rules Applied
- Only authenticated users can upload
- Only users can delete their own images
- Public read access for all images in media/articles/ folder
- Upload path must match authenticated user ID

---

## Data Types Reference

| Field | Type | Example | Required |
|-------|------|---------|----------|
| id | string | "article_123_abc" | Yes |
| title | string | "Flutter 3.0 Released" | Yes |
| description | string | "New features in Flutter..." | Yes |
| content | string | "Today Flutter released..." | Yes |
| author | string | "John Doe" | Yes |
| source | string | "NewsAPI" \| "User-Generated" | Yes |
| publishedAt | timestamp | 2024-01-15T10:30:00Z | Yes |
| urlToImage | string | "gs://bucket/media/articles/article_123_thumbnail.jpg" | No |
| url | string | "https://newsapi.org/article/..." | No |
| category | string | "technology" | No |
| createdAt | timestamp | 2024-01-15T10:30:00Z | Yes |
| updatedAt | timestamp | 2024-01-15T11:45:00Z | Yes |
| createdBy | string | "user_uid_123" | Yes |
| isUserGenerated | boolean | true \| false | Yes |
| isSaved | boolean | true \| false | Yes |
| tags | array | ["flutter", "mobile"] | No |
| status | string | "published" \| "draft" | Yes |

---

## Firestore Indexes

### Recommended Indexes for Efficient Queries

1. **Articles by Category and Timestamp**
   - Collection: `articles`
   - Fields: `category` (Ascending), `publishedAt` (Descending)
   - Use case: Filtering articles by category

2. **User Generated Articles by Creator**
   - Collection: `articles`
   - Fields: `createdBy` (Ascending), `createdAt` (Descending)
   - Use case: Listing articles created by specific user

3. **Articles by Status and Category**
   - Collection: `articles`
   - Fields: `status` (Ascending), `category` (Ascending), `publishedAt` (Descending)
   - Use case: Admin filtering and moderation

4. **User Saved Articles**
   - Collection: `articles`
   - Fields: `isUserGenerated` (Ascending), `isSaved` (Descending)
   - Use case: Finding popular user-generated articles

---

## Example Article Document

### From NewsAPI (Read-only)
```json
{
  "id": "newsapi_12345",
  "title": "Flutter 3.0 Launches with New Features",
  "description": "Google announces Flutter 3.0 with significant performance improvements",
  "content": "At Google I/O 2023, the Flutter team unveiled version 3.0...",
  "author": "Google Flutter Team",
  "source": "NewsAPI",
  "publishedAt": "2023-05-10T14:30:00Z",
  "urlToImage": "gs://bucket/media/articles/newsapi_12345_thumbnail.jpg",
  "url": "https://flutter.dev/...",
  "category": "technology",
  "createdAt": "2023-05-10T14:30:00Z",
  "updatedAt": "2023-05-10T14:30:00Z",
  "createdBy": "system",
  "isUserGenerated": false,
  "isSaved": false,
  "tags": ["flutter", "google", "mobile", "cross-platform"],
  "status": "published"
}
```

### User-Generated Article
```json
{
  "id": "user_article_67890",
  "title": "My Experience Learning Flutter in 72 Hours",
  "description": "A journalist's journey learning Flutter and building this app",
  "content": "Three days ago, I had never heard of Flutter. Today, I have built...",
  "author": "Jane Smith",
  "source": "User-Generated",
  "publishedAt": "2024-01-15T10:30:00Z",
  "urlToImage": "gs://bucket/media/articles/user_article_67890_thumbnail.jpg",
  "url": null,
  "category": "technology",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z",
  "createdBy": "uid_user_jane_123",
  "isUserGenerated": true,
  "isSaved": true,
  "tags": ["flutter", "learning", "mobile-development"],
  "status": "published"
}
```

---

## Query Examples

### Get all published articles ordered by date
```
db.collection("articles")
  .where("status", "==", "published")
  .orderBy("publishedAt", "descending")
  .limit(20)
```

### Get user's articles
```
db.collection("articles")
  .where("createdBy", "==", userId)
  .orderBy("createdAt", "descending")
```

### Get articles by category
```
db.collection("articles")
  .where("category", "==", "technology")
  .where("status", "==", "published")
  .orderBy("publishedAt", "descending")
```

### Search articles by tags
```
db.collection("articles")
  .where("tags", "array-contains", "flutter")
  .where("status", "==", "published")
```

---

## Migration Notes

- Initial data from NewsAPI will be seeded into the `articles` collection
- Each article must have a unique `id` field
- Cloud Storage images must be uploaded before article document is created
- `createdAt` and `updatedAt` should use server timestamps
