import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haber_cepte/app/views/home/models/news_model.dart';

class SavedNewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveNews(NewsModel news) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Kullanıcı bulunamadı');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_news')
        .doc(news.title.hashCode.toString())
        .set({
      'title': news.title,
      'description': news.description,
      'imageUrl': news.imageUrl,
      'sourceName': news.sourceName,
      'publishedAt': news.publishedAt,
      'articleUrl': news.articleUrl,
      'category': news.category,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<NewsModel>> getSavedNews() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Kullanıcı bulunamadı');
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_news')
        .orderBy('savedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return NewsModel(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        sourceName: data['sourceName'] ?? '',
        publishedAt: data['publishedAt'] ?? '',
        articleUrl: data['articleUrl'] ?? '',
        category: data['category'] ?? '',
      );
    }).toList();
  }

  Future<void> deleteSavedNews(NewsModel news) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Kullanıcı bulunamadı');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_news')
        .doc(news.title.hashCode.toString())
        .delete();
  }
}