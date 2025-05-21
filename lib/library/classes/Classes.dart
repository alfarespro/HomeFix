// lib/services/api/job_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Jop Model
class Jop {
  String id;
  String title;
  double price;
  String description;
  String category;
  String subCategory;
  Rating rating;
  String mobileNumber;
  String city;
  String town;
  List<String> images;
  String? videoUrl; // حقل جديد لتخزين رابط الفيديو
  String userId;
  DateTime createdAt;

  Jop({
    this.id = '',
    this.title = '',
    this.price = 0.0,
    this.description = '',
    this.category = '',
    this.subCategory = '',
    required this.rating,
    this.mobileNumber = '',
    this.city = '',
    this.town = '',
    this.images = const [],
    this.videoUrl,
    this.userId = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Jop.fromJson(Map<String, dynamic> json) {
    return Jop(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subcategory'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      city: json['city'] ?? '',
      town: json['town'] ?? '',
      userId: json['userId'] ?? '',
      videoUrl: json['videoUrl'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      rating: json['rating'] == null
          ? Rating(rate: 0, count: 0)
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      images: json['images'] is List ? List<String>.from(json['images']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'subcategory': subCategory,
      'rating': rating.toJson(),
      'mobileNumber': mobileNumber,
      'city': city,
      'town': town,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'images': images,
      if (videoUrl != null) 'videoUrl': videoUrl,
    };
  }
}

// Rating Model
class Rating {
  double rate;
  int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] ?? 0.0).toDouble(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}

// Comment Model
class Comment {
  String id;
  String userId;
  String username;
  Rating rating;
  String comment;
  String userImage;
  DateTime createdAt;

  Comment({
    this.id = '',
    required this.userId,
    required this.username,
    required this.rating,
    required this.comment,
    required this.userImage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      rating: json['rating'] == null
          ? Rating(rate: 0, count: 0)
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      comment: json['comment'] ?? '',
      userImage: json['userImage'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'rating': rating.toJson(),
      'comment': comment,
      'userImage': userImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Filter Model
class Filter {
  String category = 'any';
  String SubCategory = 'any';
  String city = 'any';
  String town = 'any';
  Filter({
    this.category = 'any',
    this.SubCategory = 'any',
    this.city = 'any',
    this.town = 'any',
  });
}
