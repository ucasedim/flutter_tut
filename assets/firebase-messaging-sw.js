importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyAcWf7-fdnB2LdWBVMocLWsaeSIpA3NEiA',
        appId: '1:949694906192:web:c74d351b841e7e3fd53655',
        messagingSenderId: '949694906192',
        projectId: 'instragram-tutc',
        authDomain: 'instragram-tutc.firebaseapp.com',
        databaseURL: 'https://instragram-tutc-default-rtdb.asia-southeast1.firebasedatabase.app',
        storageBucket: 'instragram-tutc.appspot.com',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);

      const notificationTitle = m.notification.title;
      const notificationOptions = {
        body: m.notification.body,
      };

      self.registration.showNotification(notificationTitle,
        notificationOptions);

});
