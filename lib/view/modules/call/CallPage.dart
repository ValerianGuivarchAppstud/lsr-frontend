import 'dart:async';
import 'dart:html';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Character.dart';

import '../../../domain/models/Apotheose.dart';
import '../../widgets/common/LoadingWidget.dart';
import 'CallState.dart';
import 'CallViewModel.dart';

const appId = "3eac4da1625d4bde816a6686c73e7b03";
const channel = "L7R-visio";

class CallPage extends StatefulWidget {
  final CallViewModel callViewModel;

  CallPage(this.callViewModel, {required Key key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState(this.callViewModel);
}

class _CallPageState extends State<CallPage> {
  CallViewModel callViewModel;

  RtcEngine? _engine;

  _CallPageState(this.callViewModel);

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine?.enableVideo();
    await _engine?.disableAudio();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(ClientRole.Broadcaster);
  }

  Future<void> initAgora() async {
    void _addAgoraEventHandlers() {
      _engine?.setEventHandler(RtcEngineEventHandler(error: (code) {
        setState(() {
          final info = 'onError: $code';
        });
      }, joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          callViewModel.join(uid);
        });
      }, /*leaveChannel: (stats) {
        setState(() {
          _users.clear();
        });
      },*/ userJoined: (uid, elapsed) {
        setState(() {
          callViewModel.newUser(uid);
        });
      }, userOffline: (uid, elapsed) {
        setState(() {
          callViewModel.removeUser(uid);
        });
      }));
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await window.navigator.getUserMedia(video: true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    configuration.orientationMode = VideoOutputOrientationMode.FixedLandscape;
    await _engine?.setVideoEncoderConfiguration(configuration);
  }

  @override
  Widget build(BuildContext context) {
    callViewModel.getToken();
    return StreamBuilder<CallState>(
        stream: callViewModel.streamController.stream,
        initialData: callViewModel.getState(),
        builder: (context, state) {
          if (state.data != null) {
            if (!state.data!.uiState.joined && !state.data!.showLoading) {
              print("PROUT");
              CallUIState uiState = state.data!.uiState;
             uiState.joined = true;
              callViewModel.updateUi(uiState);
              _engine?.joinChannel(state.data!.token, channel, null, 0);
            }

            if (state.data?.showLoading ?? true) {
              const oneSec = Duration(seconds: 1);
              Timer.periodic(oneSec,
                      (Timer t) => callViewModel.getCall());
            }
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Stack(
                  children: <Widget>[
                    _viewRows(state.data?.uiState.pjDisplay ?? true, state.data?.uiState.uid,
                        state.data?.charactersUid, state.data?.connectedUsersUid ?? [])
                  ],
                ),
              ),
            );
          } else {
            return LoadingWidget(
                key: Key(
                  "Loading visio",
                ));
          }
        });
  }

  /// Helper function to get list of native views
  Map<int, Widget> _getRenderViews(List<int> usersUid, int? currentUid) {
    final Map<int, Widget> list =new Map();
    list[currentUid ?? 0] = RtcLocalView.SurfaceView();
    usersUid.forEach((int uid) {
      list[uid] = RtcRemoteView.SurfaceView(uid: uid, channelId: channel);
    });
    /*for (int i = 0; i < 4; i++) {
      list.add(SizedBox(
        child: Container(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
        ),
      ));
    }*/
    return list;
  }

  /// Video view wrapper
  Widget _videoView(Widget view, int rowNumber, bool pjDisplay, Character? character) {
    double w =
        MediaQuery.of(context).size.width / (rowNumber * (pjDisplay ? 2 : 3));
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      width: w,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
        view,if( character != null) Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                foregroundImage: character.apotheose == Apotheose.NONE
                    ? NetworkImage(character.picture)
                    : NetworkImage(
                    character.pictureApotheose != ""
                        ? character.pictureApotheose
                        : character.picture),
              ),
              Text('  '+character.name+ (character.playerName !=null ? '('+ character.playerName!+')' : '' ))
            ],),])
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<int> userUids, int rowNumber, bool pjDisplay, List<Character>? charactersUid, Map<int, Widget> views) {

    List<Widget> wrappedViews = [];
    for(int uid in views.keys) {
      List<Character>? character = charactersUid?.where((element) => element.uid == uid).toList();
      if((character?.length ?? 0) > 0) {
        wrappedViews.add(_videoView(views[uid]!, rowNumber, pjDisplay, character?[0]));
      } else {
        wrappedViews.add(_videoView(views[uid]!, rowNumber, pjDisplay, null));
      }
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows(bool pjDisplay, int? currentUid, List<Character>? charactersUid, List<int> users) {
    final views = _getRenderViews(users, currentUid);
    print("VISIO ${views.length}");
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 1), 1, pjDisplay, charactersUid, views),
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 1), 1, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(1, 2), 1, pjDisplay, charactersUid, views),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 2), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(2, 3), 2, pjDisplay, charactersUid, views),
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 2), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(2, 4), 2, pjDisplay, charactersUid, views),
          ],
        ));
      case 5:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 2), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(2, 4), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(4, 5), 2, pjDisplay, charactersUid, views),
          ],
        ));
      case 6:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 2), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(2, 4), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(4, 6), 2, pjDisplay, charactersUid, views),
          ],
        ));
      case 7:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 2), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(2, 4), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(4, 6), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(6, 7), 2, pjDisplay, charactersUid, views),
          ],
        ));
      case 8:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 2), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(2, 4), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(4, 6), 2, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(6, 8), 2, pjDisplay, charactersUid, views),
          ],
        ));
      case 9:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.keys.toList().sublist(0, 3), 3, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(3, 6), 3, pjDisplay, charactersUid, views),
            _expandedVideoRow(views.keys.toList().sublist(6, 9), 3, pjDisplay, charactersUid, views),
          ],
        ));
      case 10:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.keys.toList().sublist(0, 2), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(2, 5), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(5, 8), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(8, 10), 3, pjDisplay, charactersUid, views),
              ],
            ));
      case 11:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.keys.toList().sublist(0, 3), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(3, 6), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(6, 9), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(9, 11), 3, pjDisplay, charactersUid, views),
              ],
            ));
      case 12:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.keys.toList().sublist(0, 3), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(3, 6), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(6, 9), 3, pjDisplay, charactersUid, views),
                _expandedVideoRow(views.keys.toList().sublist(9, 12), 3, pjDisplay, charactersUid, views),
              ],
            ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
/* Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }*/

  /// Info panel to show logs
/*Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Text("null");  // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }*/

// Create UI with local view and remote view
/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L7R - visio'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 300,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? RtcLocalView.SurfaceView()
                    : CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: channel,
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }*/
}
