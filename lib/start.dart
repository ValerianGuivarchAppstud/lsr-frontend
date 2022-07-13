

/*
Future<void> mainCommon(String env) async {
  // Always call this if the main method is asynchronous
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON config into memory
  await ConfigReader.initialize(env);
}

void main() {
  mainCommon("dev");
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _characterService =
  SheetService(characterProvider: CharacterProvider(NetworkingConfig()), rollProvider: RollProvider(NetworkingConfig()));
  @override
  Widget build(BuildContext context) {
    return Injector(
      sheetService: _characterService,
      characterSheetViewModel: CharacterSheetViewModel(_characterService),
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
  // TODO check, pkoi il est deux fois ?
  final _characterService = SheetService(
      characterProvider: CharacterProvider(NetworkingConfig()), rollProvider: RollProvider(NetworkingConfig()));

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Widget characterPage = CharacterPage(characterName: "ToCheck",key: Key('CharacterPage'));

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
        sheetService: _characterService,
        characterSheetViewModel: CharacterSheetViewModel(_characterService),
        key: Key("main"),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Les Sept Rois'),
          ),
          body: Center(
            child: getBody(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.tealAccent,
            selectedItemColor: Colors.blue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.character),
                label: 'Personnage',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.dice),
                label: 'Lancer',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.spell),
                label: 'Magie',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.fight),
                label: 'Combat',
              ),
            ],
            currentIndex: _selectedIndex,
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
*/