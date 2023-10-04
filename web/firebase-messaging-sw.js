importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");
importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-database.js');


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
messaging.onBackgroundMessage((payload) => {

    const username = localStorage.getItem('webDevNoti');

    console.log('Received background message ', payload);
    console.log('Received background message ', username);

    // Customize notification details
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: payload.notification.icon // Optional: you can customize this
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});

/*
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);

      const notificationTitle = m.notification.title;
      const notificationOptions = {
        body: m.notification.body,
      };

      //self.registration.showNotification(notificationTitle , notificationOptions);

});
*/