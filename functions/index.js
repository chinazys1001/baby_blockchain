const functions = require("firebase-functions");
const axios = require("axios");
const admin = require("firebase-admin");
const { firestore } = require("firebase-admin");

admin.initializeApp();

// checking mempool every 5 minutes
exports.checkMempool = functions.pubsub.schedule("every 5 minutes").onRun(async (context) => {
    const db = admin.firestore();
  
    await db.collection("mempool").get().then(async (collection) => {
        // if there are any docs except placeholder, triggering server
        if (collection.docs.length > 1) {
            await axios.post("https://server-node-uuts3zsfqa-lm.a.run.app/new-transaction").then((response) => {
                console.log(response.data);
            });
        }
    });      
});
  
  
