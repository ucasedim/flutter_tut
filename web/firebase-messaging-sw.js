importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");


firebase.initializeApp({
  apiKey: 'AIzaSyALSZ92G6sdeaylidr1Z65a6QbroZKMyDE',
  appId: '1:423719724937:web:ccc2b55b5e145c32552358',
  messagingSenderId: '423719724937',
  projectId: 'wowpress-beta',
  authDomain: 'wowpress-beta.firebaseapp.com',
  storageBucket: 'wowpress-beta.appspot.com',
  measurementId: 'G-Q3PBDRW224',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
/*
messaging.onMessage(function(payload){
        console.log('onMessage: ', payload);
        var title = "고라니 서비스";
        var options = {
                body: payload.notification.body
        };

        var notification = new Notification(title, options);
});

messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
    const notificationTitle = m.notification.title;
    const notificationOptions = {
        body: m.notification.body,
    };
    self.registration.showNotification(notificationTitle,notificationOptions);
});
*/