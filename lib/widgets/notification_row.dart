import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/model/user.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SubscribeRow extends StatefulWidget {

  final String notificationKey;
  const SubscribeRow({
    super.key,
    required String this.notificationKey,
  });

  @override
  State<SubscribeRow> createState() => _SubscribeRowState();
}

class _SubscribeRowState extends State<SubscribeRow> {

  //SubscribeWidgetProvider swp = SubscribeWidgetProvider();
  @override
  void initState() {
    super.initState();
    //swp.onUpdated = () =>setState(() {});
  }

  @override
  Widget build(BuildContext context) {

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
              value: _swp.getSubscribeOption(widget.notificationKey!),
              //value: context.watch<SubscribeWidgetProvider>().getSubscribeOption(widget.notificationKey),
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool value) {
                print('bool value : ${value}');
                  setState(() {
                    _swp.setSubscribeOption(widget.notificationKey, value ?? false ,user.uid);
                  });
              },
            ),
          ),
        ],
      ),
    );
  }

}
