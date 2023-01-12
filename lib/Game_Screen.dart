import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/Utils.dart';
import 'dart:math';
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AudioCache audioCache = AudioCache(prefix: "sounds/");
  String word = wordsList[Random().nextInt(wordsList.length)];
  List gussedalphabets = [];
  int points = 0;
  int ststus = 0;
  bool soundon =true;
  List images=[
    "images/hangman0.png",
    "images/hangman1.png",
    "images/hangman2.png",
    "images/hangman3.png",
    "images/hangman4.png",
    "images/hangman5.png",
    "images/hangman6.png",
  ];

playsound(String sound) async{
  if(soundon){
    await audioCache.play(sound);
  }

}

  opendailog(String title){
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.purpleAccent
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
              style: retrostyl(25,Colors.white,FontWeight.bold),
              textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text("Your point: $points",
              style: retrostyl(20,Colors.white,FontWeight.bold),
              textAlign: TextAlign.center,),
              Container(
                margin: EdgeInsets.only(top: 20),
                width:  MediaQuery.of(context).size.width/2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        ststus =0;
                        gussedalphabets.clear();
                        points=0;
                        word =  wordsList[Random().nextInt(wordsList.length)];
                      });
                      playsound("restart.mp3");
                    },
                    child: Center(child: Text("play again",style: retrostyl(20,Colors.black
                        ,FontWeight.bold),),),
                ),
              )
            ],
          ),
        ),

      );
        });
  }

  String handletext(){
    String displayword ="";
    for( int i = 0; i < word.length; i++){
      String char = word[i];
      if(gussedalphabets.contains(char)){
        displayword += char+" ";
      }else{
        displayword += "? ";
      }
    }
    return displayword;
  }
  checkletter(String alphabet){
    if(word.contains(alphabet)){

     setState(() {
       gussedalphabets.add(alphabet);
       points += 5;
     });
     playsound("correct.mp3");
    }else if(ststus != 6){
      setState(() {
        ststus +=1;
        points -= 5;
      });
      playsound("wrong.mp3");
    }else{
      opendailog("you lost !");
      playsound("lost.mp3");
    }

    bool isWon = true;
    for( int i = 0; i < word.length; i++){
      String char = word[i];
     if(!gussedalphabets.contains(char)){
       setState(() {
         isWon= false;
       });
       break;
     }
    }
    if(isWon){
      opendailog("hurray, you won");
      playsound("won.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('HangMan',style: retrostyl(30,Colors.white,FontWeight.w700),
        ),
        actions: [
          IconButton(
            iconSize: 40,
            onPressed: (){
             setState(() {
               soundon = !soundon;

             });
            },
            icon: Icon(
              soundon?  Icons.volume_up_sharp : Icons.volume_off_sharp),
          color: Colors.purpleAccent,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/3.5,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent
                ),
                child: Text('$points points',style: retrostyl(25,Colors.black,FontWeight.w700),),
              ),
              SizedBox(
                height: 20,
              ),
              Image(
                  width: 155,
                  height: 155,
                  image: AssetImage(images[ststus]),
              color: Colors.white,
              fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text("${7-ststus} Lives left",style: retrostyl(20,Colors.grey,FontWeight.w700),
              ),
              SizedBox(
                height: 30,
              ),
              Text(handletext(),style: retrostyl(35,Colors.white,FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics() ,
                padding: EdgeInsets.only(left: 10),
                childAspectRatio: 1.3,
                children: letters.map((alphabet) {
                  return InkWell(
                    onTap: ()=> checkletter(alphabet),
                      child: Center(child: Text(alphabet,style: retrostyl(20,Colors.white,FontWeight.w700))));
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
