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

    console.log("/////////////???");
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/flutter_logo.png' // if you have a logo
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});

/*
firebase.initializeApp({
    apiKey: 'AIzaSyALSZ92G6sdeaylidr1Z65a6QbroZKMyDE',
    appId: '1:423719724937:web:ccc2b55b5e145c32552358',
    messagingSenderId: '423719724937',
    projectId: 'wowpress-beta',
    authDomain: 'wowpress-beta.firebaseapp.com',
    storageBucket: 'wowpress-beta.appspot.com',
    measurementId: 'G-Q3PBDRW224',
});
*/
// Necessary to receive background messages:
//const messaging = firebase.messaging();

// Optional:
/*
messaging.onBackgroundMessage((payload) => {
    console.log("ddd");

    const username = 'web test';
    //const username = localStorage.getItem('webDevNoti');
    //console.log('Received background message ', payload);
    //console.log('Received background message ', username);
    // Customize notification details
    const notificationTitle = payload.notification.title;

    const notificationOptions = {
        body: payload.notification.body,
        icon: payload.notification.icon // Optional: you can customize this
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
*/
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