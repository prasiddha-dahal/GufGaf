import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
  });

  factory ChatModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return ChatModel(
      id: documentId,
      participants: List<String>.from(
        json['participants'] ?? [],
      ),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? (json['lastMessageAt'] as Timestamp).toDate()
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
      'createdAt': createdAt,
    };
  }
}