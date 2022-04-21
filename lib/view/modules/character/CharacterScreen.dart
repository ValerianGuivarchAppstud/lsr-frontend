
import 'package:flutter/material.dart';
import 'package:lsr/view/modules/character/CharacterView.dart';

import '../../../utils/Injector.dart';
import '../../widgets/StatRow.dart';
import 'CharacterPresenter.dart';
import 'CharacterState.dart';
import 'CharacterWidget.dart';


class CharacterPage extends StatefulWidget {
  CharacterPage({required Key key}) : super(key: key);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}



class _CharacterPageState extends State<CharacterPage> with CharacterView {
  late CharacterPresenter presenter;
  late TextEditingController noteFieldController;

  @override
  void initState() {
    super.initState();
    noteFieldController  = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    presenter = /*(widget.initPresenter != null
        ? widget.initPresenter(this)
        : */CharacterPresenter(
        view: this, interactor: Injector.of(context).sheetService);
    presenter.triggerLoad();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tearDown(); // from CharacterView
    presenter.tearDown();
    noteFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder<CharacterSheetState>(
      stream: presenter.stream,
      initialData: presenter.latest,
      builder: (context, characterState) {
        return Scaffold(
          body: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: CharacterWidget(
                key: Key("CharacterState"),
                character: characterState.data?.character,
                loading: characterState.data?.showLoading ?? true,
                error: characterState.data?.error,
                size: size,
                noteFieldController: noteFieldController,
              presenter : presenter),
        )
        )
        );
      },
    );
  }
}

/*
class CharacterPage extends Page {

  CharacterPage() : super();

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) =>
          CharacterScreen(
          ),
    );
  }
}



class CharacterScreen extends StatefulWidget {

  const CharacterScreen() : super();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var size = MediaQuery
        .of(context)
        .size;
    return Consumer(builder: (context, watch, child) {
      final _futureAsyncValue = watch(characterStateProvider);
      Character? currentCharacter = _futureAsyncValue.when(
          data: (data) => data,
          loading: () => null,
          error: (e, st) => null
      );
      return Scaffold(
      body: Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 62),
                      child: Image.asset(
                        "images/vent.jpg",
                        fit: BoxFit.cover,
                        height: 100,
                        width: size.width,
                      )),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 62,
                        backgroundColor: Colors.white,
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        foregroundImage:
                        AssetImage("images/portraits/Viktor.png"),
                      )
                    ],
                  )
                ],
              ),
              Text(
                currentCharacter?.name ??" loading",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Champion du Vent, niveau 16",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatRow(
                          statName: "Chair",
                          statValue: 3.toString()
                      ),
                      StatRow(
                          statName: "Esprit",
                          statValue: 5.toString()
                      ),
                      StatRow(
                          statName: "Essence",
                          statValue: 7.toString()
                      ),
                    ],
                  ), Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatRow(
                          statName: "Lux",
                          statValue: "Voyageur"
                      ),
                      StatRow(
                          statName: "Umbra",
                          statValue: "Pipelette"
                      ),
                      StatRow(
                          statName: "Secunda",
                          statValue: "Arbolesque"
                      ),
                    ],
                  ),
                ],
              ),
            ]
        )
        ,
      )
      ,
    ),);
  }

  );
}

CircleAvatar profilePicture({required double radius}) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.blue,
    foregroundImage: NetworkImage(
        "https://images.pexels.com/photos/1756086/pexels-photo-1756086.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
  );
}

Text simpleText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
    textAlign: TextAlign.center,
  );
}

Image fromAsset({required double height, required double width}) {
  return Image.asset(
    "images/beach.jpg",
    fit: BoxFit.cover,
    height: height,
    width: width,
  );
}

Image fromNetwork() {
  return Image.network(
    "https://images.pexels.com/photos/1756086/pexels-photo-1756086.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    height: 200,
  );
}

Text spanDemo() {
  return Text.rich(
      TextSpan(text: "Salut", style: TextStyle(color: Colors.red), children: [
        TextSpan(
            text: "second style",
            style: TextStyle(fontSize: 30, color: Colors.grey)),
        TextSpan(
            text: "A l'infini",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue))
      ]));
}}
*/