import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime? createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.createdAt,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return MessageModel(
      id: documentId,
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}