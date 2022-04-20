import 'package:flutter/material.dart';


class MyAppBasicWidget extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BasicsPage(),
    );
  }
}

class BasicsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    print( "size: $size");
    print("platform: $platform");
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon app basique"),
        leading: Icon(Icons.favorite),
        actions: [
          Icon(Icons.handyman),
          Icon(Icons.border_color)
        ],
        centerTitle: true,
        elevation: 7.5,
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          //margin: EdgeInsets.all(10),
          //padding: EdgeInsets.only(top: 150),
          child: Center(
              child: Card(
                child: Padding(
                    padding: EdgeInsets.all(3),
                    child: SingleChildScrollView(
                      //scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          Text("Test de la colonne"),
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              fromAsset(height: 200, width: size.width),
                              Padding(
                                padding: EdgeInsets.only(top: 150),
                                child: profilePicture(radius: 50),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.favorite),
                                  Icon(Icons.height),
                                  Spacer(),
                                  Text("Un autre élément"),
                                ],
                              )


                            ],
                          ),
                          Divider(
                            color: Colors.teal,
                            height: 10,
                            thickness: 1,
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            height: 200,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              image: DecorationImage(
                                  image: AssetImage("images/beach.jpg"),
                                  fit: BoxFit.cover
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow,
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ],
                              //shape: BoxShape.circle,
                              borderRadius: BorderRadius.all(Radius.circular(15)),

                            ),
                            child: Text("Container"),


                          ),

                          Container(
                              color: Colors.teal,
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  profilePicture(radius: 40),
                                  //fromAsset(height: 80, width: 80),
                                  Expanded(
                                      child: simpleText("Matthieu Codabee"))


                                ],
                              )
                          )
                          ,
                          fromNetwork(),
                          spanDemo(),
                          fromNetwork()
                        ],
                      ),
                    )

                ),
                elevation: 7.5,
                //color: Colors.teal,
                margin: EdgeInsets.all(10),
              )
          )
      ),
    );
  }


  CircleAvatar profilePicture({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue,
      foregroundImage: NetworkImage("https://images.pexels.com/photos/1756086/pexels-photo-1756086.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
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
        TextSpan(
            text: "Salut",
            style: TextStyle(color: Colors.red),
            children: [
              TextSpan(
                  text: "second style",
                  style: TextStyle(fontSize: 30, color: Colors.grey)
              ),
              TextSpan(
                  text: "A l'infini",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue
                  )
              )
            ]
        )
    );
  }

}




