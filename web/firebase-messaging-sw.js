importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyB7wZb2tO1-Fs6GbDADUSTs2Qs3w08Hovw',
  appId: '1:406099696497:web:87e25e51afe982cd3574d0',
  messagingSenderId: '406099696497',
  projectId: 'flutterfire-e2e-tests',
  authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
  databaseURL:
      'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
  storageBucket: 'flutterfire-e2e-tests.appspot.com',
  measurementId: 'G-JN95N1JV2E',
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