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

  Widget build( BuildContext context , WidgetRef ref){
    final userProvider = ref.watch(userInfoProcessProvider);
    final subscribeProvider = ref.watch(notiSubscribeProvider);
    ref.read(notiUserProvider.notifier).refreshUser();
    //return Text("errrrrr");
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child:
            Center(
              child: Text(
                subscribeProvider!.getKeyName(notificationKey),
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
              //value: context.watch<SubscribeWidgetProvider>().getSubscribeOption(widget.notificationKey),
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool value) async {
                var mapData = subscribeProvider.toMap();
                mapData[notificationKey] = value;
                print("bf lgg : ${subscribeProvider.toMap()}");
                ref.read(notiSubscribeProvider.notifier).setSubscribeOption(notificationKey, value, userProvider.uid);
                print("af lgg : ${subscribeProvider.toMap()}");
                ref.read(notiSubscribeProvider.notifier).state = ref.read(notiSubscribeProvider.notifier).getSubscribeOption;

                /*
                setState(() {
                  _swp.setSubscribeOption(widget.notificationKey, value ,user.uid);
                });
                 */
              },
            ),
          ),
        ],
      ),
    );
  }

}

/*
    var _swp = context.read<SubscribeWidgetProvider>();
    final User user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child:
            Center(
              child: Text(
                _swp.getKeyName(widget.notificationKey),
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
              value: _swp.getSubscribeOption(widget.notificationKey),
              //value: context.watch<SubscribeWidgetProvider>().getSubscribeOption(widget.notificationKey),
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool value) {
                print('bool value : ${value}');
                  setState(() {
                    _swp.setSubscribeOption(widget.notificationKey, value ,user.uid);
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
*/

