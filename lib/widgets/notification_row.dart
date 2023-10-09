import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/user.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/utils/global_variables.dart';

class SubscribeRow extends ConsumerWidget {
  final String notificationKey;

  SubscribeRow({
    required this.notificationKey,
  });


  Future<Padding> fetchData(WidgetRef ref) async {
    await ref.read(notiUserProvider.notifier).refreshUser();
    await ref.read(notiSubscribeProvider.notifier).setSubscribeOptionFromFirebase();
    final userProvider = await ref.watch(notiUserProvider.notifier).getUser;
    final subscribeProvider = await ref.watch(notiSubscribeProvider.notifier).getSubscribeOption;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child:
            Center(
              child: Text(
                subscribeProvider == null ? 'providererror' : subscribeProvider.getKeyName(notificationKey),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Container(
            child:
            CupertinoSwitch(
              value: ref.read(notiSubscribeProvider.notifier).getSubscribeOptionKey(notificationKey),
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool value) async {
                var mapData = subscribeProvider?.toMap();
                mapData?[notificationKey] = value;
                print("bf lgg : ${subscribeProvider?.toMap()}");
                ref.read(notiSubscribeProvider.notifier).setSubscribeOption(notificationKey, value, userProvider!.uid);
                print("af lgg : ${subscribeProvider?.toMap()}");
                ref.read(notiSubscribeProvider.notifier).state = ref.read(notiSubscribeProvider.notifier).getSubscribeOption;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notiUserProvider);
    ref.watch(notiSubscribeProvider);
    return FutureBuilder<Padding>(
      future: fetchData(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 로딩 중
        } else if (snapshot.hasError) {
          return Text('loadError'); // 오류 발생
        } else {
          return snapshot.requireData; // 데이터 표시
        }
      },
    );
  }
}