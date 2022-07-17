import 'dart:async';
import 'dart:html';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

import 'CallState.dart';
import 'CallViewModel.dart';

const appId = "3eac4da1625d4bde816a6686c73e7b03";
// const token = "0063eac4da1625d4bde816a6686c73e7b03IABgL9zfCzqEzFSK/MW/CxQNrqYd4b8DsVgk4UfAjfNOz2eH5lEAAAAAEACPl0pWwDXUYgEAAQDANdRi";
const channel = "L7R-visio";

class CallPage extends StatefulWidget {
  CallViewModel callViewModel;

  CallPage(this.callViewModel, {required Key key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState(this.callViewModel);
}

class _CallPageState extends State<CallPage> {
  CallViewModel callViewModel;

  final _users = <int>[];
  final _infoStrings = <String>[];
  late RtcEngine _engine;

  _CallPageState(this.callViewModel);

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
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
    await _engine.enableVideo();
    await _engine.disableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  Future<void> initAgora() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    /// Add agora event handlers
    void _addAgoraEventHandlers() {
      _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      }));
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await window.navigator.getUserMedia(video: true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    configuration.orientationMode = VideoOutputOrientationMode.FixedLandscape;
    await _engine.setVideoEncoderConfiguration(configuration);
  }

  /*   @override
    Widget build(BuildContext context) {
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width < WIDTH_SCREEN
          ? MediaQuery.of(context).size.width
          : WIDTH_SCREEN;
      return StreamBuilder<CallState>(
          stream: callViewModel.streamController.stream,
          initialData: callViewModel.getState(),
          builder: (context, state) {

            callViewModel.getCall();

            return Container(
                height: height,
                width: width,
                color: Colors.white30,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (state.data == null || (state.data!.showLoading)) {
                        return LoadingWidget(
                            key: Key(
                              "LoadingWidget",
                            ));
                      } else if (state.data?.error != null) {
                        return Center(
                          child: Text(state.data!.error.toString()),
                        );
                      } else {
                        // initialize agora sdk
                        return  Center(
                            child: Stack(
                            children: <Widget>[
                            _viewRows()
                      ]));
                      }
                    })));
          });
    }

*/
  @override
  Widget build(BuildContext context) {
    callViewModel.getCall();
    return StreamBuilder<CallState>(
        stream: callViewModel.streamController.stream,
        initialData: callViewModel.getState(),
        builder: (context, state) {
          if (state.data != null)  {
//            String token = await callViewModel.getState().token ?? token2;

            _engine.joinChannel(state.data!.token, channel, null, 0);
          }
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Stack(
                children: <Widget>[_viewRows()],
              ),
            ),
          );
        });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) =>
        list.add(RtcRemoteView.SurfaceView(uid: uid, channelId: channel)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(
      width: 400,
      height: 200,
      child: Center(
        child: view,
      ),
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
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
