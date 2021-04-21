"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.onConversationCreated = functions.firestore.document("Conversations/{conversationID}").onCreate((snapshot, context) => {
    let data = snapshot.data();
    let conversationID = context.params.conversationID;
    if (data) {
        let members = data.members;
        for (let index = 0; index < members.length; index++) {
            let currentUserID = members[index];
            let remainingUserIDs = members.filter((u) => u !== currentUserID);
            remainingUserIDs.forEach((m) => {
                return admin.firestore().collection("Users").doc(m).get().then((_doc) => {
                    let userData = _doc.data();
                    if (userData) {
                        return admin.firestore().collection("Users").doc(currentUserID).collection("Conversations").doc(m).create({
                            "conversationID": conversationID,
                            "image": userData.image,
                            "name": userData.name,
                            "unseenCount": 0,
                        });
                    }
                    return null;
                }).catch(() => { return null; });
            });
        }
    }
    return null;
});


exports.onConversationUpdated = functions.firestore.document("Conversations/{chatID}").onUpdate((change, context) => {
    let data = change === null || change === void 0 ? void 0 : change.after.data();
    if (data) {
        let members = data.members;
        let lastMessage = data.messages[data.messages.length - 1];
        for (let index = 0; index < members.length; index++) {
            let currentUserID = members[index];
            let remainingUserIDs = members.filter((u) => u !== currentUserID);
            remainingUserIDs.forEach((u) => {
                return admin.firestore().collection("Users").doc(currentUserID).collection("Conversations").doc(u).update({
                    "lastMessage": lastMessage.message,
                    "timestamp": lastMessage.timestamp,
                    "type": lastMessage.type,
                    "unseenCount": admin.firestore.FieldValue.increment(1),
                });
            });
        }
    }
    return null;
});
//# sourceMappingURL=index.js.map