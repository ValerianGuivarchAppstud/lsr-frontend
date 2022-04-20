import 'package:flutter/material.dart';
import 'package:lsr/tuto/profil/profile.dart';

class ProfilePage extends StatefulWidget {

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  Profile myProfile = Profile(surname: "Matthieu", name: "Codabee");
  late TextEditingController surname;
  late TextEditingController name;
  late TextEditingController secret;
  late TextEditingController age;
  bool showSecret = false;

  Map<String, bool> hobbies = {
    "Pétanque": false,
    "Football": false,
    "Rugby": false,
    "Code": false,
    "Manga": false,
    "foooood": false
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    surname = TextEditingController();
    name = TextEditingController();
    secret = TextEditingController();
    age = TextEditingController();
    surname.text = myProfile.surname;
    name.text = myProfile.name;
    secret.text = myProfile.secret;
    age.text = myProfile.age.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    surname.dispose();
    name.dispose();
    secret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      appBar: AppBar(title: Text("Mon profil"),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              color: Colors.deepPurpleAccent.shade100,
                elevation: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(myProfile.setName()),
                      Text("Age: ${myProfile.setAge()}"),
                      Text("Taille: ${myProfile.setHeight()}"),
                      Text("Genre: ${myProfile.genderString()}"),
                      Text("Hobbies: ${myProfile.setHobbies()}"),
                      Text("Langage de programmation favori: ${myProfile.favoriteLang} "),
                      ElevatedButton(
                          onPressed: updateSecret,
                          child: Text((showSecret)?"Cacher secret": "Montrer secret")
                      ),
                      (showSecret) ? Text(myProfile.secret) : Container(height: 0, width: 0,),

                    ],

                  ),

                )

            ),
            const Divider(color: Colors.deepPurpleAccent, thickness: 2,),
            myTitle("Modifier les infos"),
            myTextField(controller: surname, hint: "Entrez votre prénom"),
            myTextField(controller: name, hint: "Entrez votre nom"),
            myTextField(controller: secret, hint: "Dites nous un secret", isSecret: true),
            myTextField(controller: age, hint: "Entrez votre age", type: TextInputType.number),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Genre: ${myProfile.genderString()}"),
                Switch(value: myProfile.gender, onChanged: ((newBool) {
                  setState(() {
                    myProfile.gender = newBool;
                  });
                })),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Taile: ${myProfile.setHeight()}"),
                Slider(
                    value: myProfile.height ,
                    min: 0,
                    max: 250,
                    onChanged: ((newHeight) {
                      setState(() {
                        myProfile.height = newHeight;
                      });
                    }))
              ],
            ),
            Divider(color: Colors.deepPurpleAccent, thickness: 2,),
            myHobbies(),
            Divider(color: Colors.deepPurpleAccent, thickness: 2,),
            myRadios()
          ],
        ),
      ),
    );
  }

  TextField myTextField({required TextEditingController controller,required String hint, bool isSecret = false, TextInputType type: TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
      keyboardType: type,
      obscureText: isSecret,
      onSubmitted: ((newValue) {
        updateUser();
      }),
    );
  }

  updateUser() {
    setState(() {
      myProfile = Profile(
        surname: (surname.text != myProfile.surname) ? surname.text: myProfile.surname,
        name: name.text,
        secret: secret.text,
        favoriteLang: myProfile.favoriteLang,
        hobbies: myProfile.hobbies,
        height: myProfile.height,
        age: int.parse(age.text),
        gender: myProfile.gender
      );
    });
  }

  updateSecret() {
    setState(() {
      showSecret = !showSecret;
    });
  }

  Column myHobbies() {
    List<Widget> widgets = [myTitle("Mes Hobbies")];
    hobbies.forEach((hobby, like) {
      Row r = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(hobby),
          Checkbox(value: like, onChanged: (newBool) {
            setState(() {
              hobbies[hobby] = newBool ?? false;
              List<String> str = [];
              hobbies.forEach((key, value) {
                if (value == true) {
                  str.add(key);
                }
              });
              myProfile.hobbies = str;
            });
          })
        ],
      );
      widgets.add(r);
    });
    return Column(children: widgets);
  }

  Column myRadios() {

    List<Widget> w = [];
    List<String> langs = ["Dart", "Swift", "Kotlin", "Java", "Python"];
    int index = langs.indexWhere((lang) => lang.startsWith(myProfile.favoriteLang));
    for (var x = 0; x < langs.length; x++) {
      Column c = Column(

        children: [
          Text(langs[x]),
          Radio(value: x, groupValue: index, onChanged: (newValue) {
            setState(() {
              myProfile.favoriteLang = langs[newValue as int];
            });
          })
        ],
      );
      w.add(c);
    }
    return Column(
      children: [
        myTitle("Langage préféré"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: w
        )
      ],
    );
  }

  Text myTitle(String text) {
    return Text(
        text,
        style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 18
        ));
  }
}