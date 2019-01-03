import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalium_wallet_flutter/colors.dart';
import 'package:kalium_wallet_flutter/dimens.dart';
import 'package:kalium_wallet_flutter/styles.dart';
import 'package:kalium_wallet_flutter/kalium_icons.dart';
import 'package:kalium_wallet_flutter/ui/widgets/buttons.dart';
import 'package:kalium_wallet_flutter/ui/widgets/sheets.dart';
import 'package:kalium_wallet_flutter/ui/util/ui_util.dart';
import 'package:kalium_wallet_flutter/model/wallet.dart';
import 'package:kalium_wallet_flutter/appstate_container.dart';

class KaliumReceiveSheet {
  KaliumWallet _wallet;

  // Address copied items
  // Initial constants
  static const String _copyAddress = 'Copy Address';
  static const String _addressCopied = 'Address Copied';
  static const TextStyle _copyButtonStyleInitial = KaliumStyles.TextStyleButtonPrimary;
  static const Color _copyButtonColorInitial = KaliumColors.primary;
  // Current state references
  String _copyButtonText;
  TextStyle _copyButtonStyle;
  Color _copyButtonBackground;
  // Timer reference so we can cancel repeated events
  Timer _addressCopiedTimer;

  mainBottomSheet(BuildContext context) {
    _wallet = StateContainer.of(context).wallet;
    // Set initial state of copy button
    _copyButtonText = _copyAddress;
    _copyButtonStyle = _copyButtonStyleInitial;
    _copyButtonBackground =_copyButtonColorInitial;

    showKaliumHeightEightSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Icon(KaliumIcons.close, size: 16, color: KaliumColors.text),
                        padding: EdgeInsets.all(17.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),

                    //Container for the address text
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: threeLineAddressText(
                          _wallet.address),
                    ),

                    //This container is a temporary solution for the alignment problem
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(top: 10.0, right: 10.0),
                    ),
                  ],
                ),

                //MonkeyQR which takes all the available space left from the buttons & address text
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 35, bottom: 35),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/monkeyQR.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),

                //A column with "Scan QR Code" and "Send" buttons
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.fromLTRB(Dimens.BUTTON_TOP_DIMENS[0],
                                                    Dimens.BUTTON_TOP_DIMENS[1],
                                                    Dimens.BUTTON_TOP_DIMENS[2],
                                                    Dimens.BUTTON_TOP_DIMENS[3]),
                            child: FlatButton(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                              color: _copyButtonBackground,
                              child: Text(_copyButtonText,
                                  textAlign: TextAlign.center,
                                  style: _copyButtonStyle),
                              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: _wallet.address));
                                setState(() {
                                  // Set copied style
                                  _copyButtonText = _addressCopied;
                                  _copyButtonStyle = KaliumStyles.TextStyleButtonPrimaryGreen;
                                  _copyButtonBackground = KaliumColors.green;
                                  if (_addressCopiedTimer != null) {
                                    _addressCopiedTimer.cancel();
                                  }
                                  _addressCopiedTimer = new Timer(
                                      const Duration(milliseconds: 800), () {
                                    setState(() {
                                      _copyButtonText = _copyAddress;
                                      _copyButtonStyle = _copyButtonStyleInitial;
                                      _copyButtonBackground = _copyButtonColorInitial;
                                    });
                                  });
                                });
                              },
                              highlightColor: KaliumColors.success30,
                              splashColor: KaliumColors.successDark,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildKaliumButton(KaliumButtonType.PRIMARY_OUTLINE,
                            'Share Address', Dimens.BUTTON_BOTTOM_DIMENS),
                      ],
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }
}