const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// added .region("europe-west1") but did not deployed this yet to firebase
// function needs to be deployed via the terminal >>> check firebase docs
// ESLint is very precise with the rules >> do format document with the right ESlint formatter
exports.addAdmin = functions.region("europe-west1")
    .https.onCall((data, context) => {
      return admin.auth().getUserByEmail(data.email).then(
          (user) => admin.auth()
              .setCustomUserClaims(user.uid, {moderator: true}))
          .then(() => ({message: "Succesful created an admin"}))
          .catch((error) => {
            return error;
          });
    });


