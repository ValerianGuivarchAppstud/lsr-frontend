import 'package:flutter/material.dart';
import 'package:lsr/domain/services/CharacterService.dart';
import 'package:lsr/utils/Injector.dart';
import 'package:lsr/utils/api/NetworkingConfig.dart';
import 'package:lsr/view/modules/character/CharacterScreen.dart';

import 'config/config_reader.dart';
import 'data/api/CharacterProvider.dart';


Future<void> mainCommon(String env) async {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON config into memory
  await ConfigReader.initialize(env);
}

void main() {
  runApp(MyApp());
}

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Les Sept Rois',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MainStatefulWidget(),
    );
  }
}
class MyApp extends StatelessWidget {
  final _characterService =
  CharacterService(characterProvider: CharacterProvider(NetworkingConfig()));

  @override
  Widget build(BuildContext context) {
    return Injector(
      characterService: _characterService,
      key: Key("Main"),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Les Sept Rois',
          home: MainStatefulWidget()//CharacterPage(key: Key("CharacterPage"),
          //),
      ),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Les Sept Rois',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MainStatefulWidget(),
    );
  }
}
*/



class MainStatefulWidget extends StatefulWidget {
  const MainStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MainStatefulWidget> createState() => _MainStatefulWidgetState();
}

class _MainStatefulWidgetState extends State<MainStatefulWidget> {
  final _characterService = CharacterService(
      characterProvider: CharacterProvider(NetworkingConfig()));

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Widget characterPage = CharacterPage(key: Key('CharacterPage'));

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
        characterService: _characterService,
        key: Key("main"),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Les Sept Rois'),
          ),
          body: Center(
            child: getBody(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Personnage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Sorts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Combat',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ));
  }

  getBody(int selectedIndex) {
    if (_selectedIndex == 0) {
      return characterPage;
    } else {
      return Text("lol");
    }
  }
}
