import 'package:flutter/material.dart';

class InteractifPage extends StatefulWidget {


  @override
  //State<StatefulWidget> createState() {
  //  return InteractifPageState();
  //}
  InteractifPageState createState() => InteractifPageState();

}

class InteractifPageState extends State<InteractifPage> {

  Color backgroundColor = Colors.white;
  Color textColor = Colors.black;
  bool textButtonPressed = true;
  IconData icon = Icons.favorite;
  String prenom = "";
  late TextEditingController controller;
  bool switchValue = true;
  double sliderValue = 50;
  bool check = false;
  Map<String, bool> courses = {
    "Carottes": false,
    "Oignon": true,
    "Abricot": false,
  };

  DateTime initialDate = DateTime.now();
  int groupValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Tout ce que l'on va faire pendant l'initialisation du Widget.
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
    //Tout ce que l'on va faire quand le widget sera dispose. Quand le widget sera supprimé
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(updateAppBarText()),),
      body: Center(child: Column(
        children: [
          TextButton(
              onPressed: updateAppBar,
              child: Row(
                children: [
                  const Icon(Icons.work),
                  textButtonText()
                ],
              ),
            style: TextButton.styleFrom(
              primary: Colors.teal,
            ),
          ),
          ElevatedButton(
              onPressed: (() => showDate(context)),
              child: Text("$initialDate"),
            onLongPress: () {
                print("Appui looooooong");
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow,
              elevation: 10,
              shadowColor: Colors.red
            ),
          ),
          IconButton(
              onPressed: setIcon,
              icon: Icon(icon),
            color: Colors.pink,
            splashColor: Colors.pinkAccent,
          ),
          TextField(
            obscureText: false,
            decoration: InputDecoration(
                hintText: "Entrez votre prénom",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
              )
            ),
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (newString) {
              setState(() {
                prenom = newString;
              });
            },
          ),
          Text(prenom),
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Entrez votre nom"),
            onChanged: ((newValue) => setState(() => print("Done: $newValue"))) ,
          ),
          Text(controller.text),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((switchValue) ? "J'aime les chats" : "Les chats sont démoniaques"),
              Switch(
                activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.redAccent,
                  value: switchValue,
                  onChanged: ((bool) {
                setState(() {
                  switchValue = bool;
                });
              }))
            ],
          ),
          Slider(
              value: sliderValue,
              min: 0,
              max: 100,
              onChanged: ((newValue) {
                setState(() {
                  sliderValue = newValue;
                });
              }),
            inactiveColor: Colors.brown,
            activeColor: Colors.yellow,
          ),
          Text("Valeur: ${sliderValue.toInt()}"),
          Checkbox(value: check, onChanged: ((newBool) => setState(() => check = newBool ?? false))),
          checks(),
          radios(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: updateColors,
        child: const Icon(Icons.build),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  updateColors() {
    setState(() {
      backgroundColor = (backgroundColor == Colors.white) ? Colors.black: Colors.white;
      textColor = (textColor == Colors.black)? Colors.white: Colors.black;
    });
  }

  updateAppBar() {
    setState(() => textButtonPressed = !textButtonPressed);
  }

  String updateAppBarText() {
    return(textButtonPressed)? "Je m'y connais un peu" : "Les interactifs";
  }

  Text textButtonText() {
    return const Text("Je suis un TextButton", style: TextStyle(
        //color: Colors.pink,
        //backgroundColor: Colors.grey
    ),);
  }

  setIcon() {
    setState(() {
      icon = (icon == Icons.favorite) ? Icons.favorite_border : Icons.favorite;
    });
  }

  Column checks() {
    List<Widget> items = [];
    courses.forEach((course, achete) {
      Widget row = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(course),
          Checkbox(value: achete, onChanged: ((newValue) {
            setState(() {
              courses[course] = newValue ?? false;
            });
          }),
          checkColor: Colors.greenAccent,
            activeColor: Colors.blueGrey,
          )
        ],
      );
      items.add(row);
    });
    return Column(children: items,);
  }

  Row radios() {
    List<Widget> radios = [];
    for (var i = 0; i < 5; i++) {
      Radio r = Radio(
        activeColor: Colors.greenAccent,
          value: i,
          groupValue: groupValue,
          onChanged: ((newValue) {
            setState(() {
              groupValue = newValue as int;
            });

          }));
      radios.add(r);
    }
    return Row(children: radios,);
  }

  showDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1978),
      lastDate: DateTime(2090),
    ).then((value) => {
      if (value != null) {
        setState(() {
          initialDate = value;
        })
      }
    });
  }

}