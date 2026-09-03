const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

const db = getFirestore();

exports.sendMessageNotification = onDocumentCreated(
  "chats/{chatId}/messages/{messageId}",
  async (event) => {
    const message = event.data?.data();

    if (!message) {
      return;
    }

    const chatId = event.params.chatId;

    const senderId = message.senderId;
    const text = message.text;

    // Get the chat
    const chatSnapshot = await db
        .collection("chats")
        .doc(chatId)
        .get();

    if (!chatSnapshot.exists) {
      return;
    }

    const chat = chatSnapshot.data();

    const participants = chat.participants;

    // Find the other user
    const receiverId = participants.find(
      (uid) => uid !== senderId,
    );

    if (!receiverId) {
      return;
    }

    // Get receiver's FCM token
    const receiverSnapshot = await db
        .collection("users")
        .doc(receiverId)
        .get();

    if (!receiverSnapshot.exists) {
      return;
    }

    const receiver = receiverSnapshot.data();

    const fcmToken = receiver.fcmToken;

    if (!fcmToken) {
      console.log("Receiver has no FCM token");
      return;
    }

    // Send notification
    await getMessaging().send({
      token: fcmToken,

      notification: {
        title: "New message",
        body: text,
      },

      data: {
        chatId: chatId,
        senderId: senderId,
      },
    });

    console.log("Notification sent successfully");
  },
);