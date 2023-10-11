importScripts('https://www.gstatic.com/firebasejs/8.6.5/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.6.5/firebase-messaging.js');
//importScripts('https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js');
//importScripts('https://www.gstatic.com/firebasejs/10.4.0/firebase-messaging.js');

    const firebaseConfig = {
        apiKey: 'AIzaSyALSZ92G6sdeaylidr1Z65a6QbroZKMyDE',
        appId: '1:423719724937:web:ccc2b55b5e145c32552358',
        messagingSenderId: '423719724937',
        projectId: 'wowpress-beta',
        authDomain: 'wowpress-beta.firebaseapp.com',
        storageBucket: 'wowpress-beta.appspot.com',
        measurementId: 'G-Q3PBDRW224',
    };
    firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/flutter_logo.png' // if you have a logo
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});