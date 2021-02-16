import 'package:flutter/material.dart';

void tn()=>runApp(Tn());

int i=0;

class Tn extends StatelessWidget {
  const Tn({Key key}) : super(key: key);
  // int i=0;

  @override
  Widget build(BuildContext context) {
    var btn=FloatingActionButton(child: Icon(Icons.zoom_in), onPressed: (){
    //  var s=Navigator.of(context);
      i++;
      Navigator.pushNamed(context,(i%2==0)?  '/':'/a');
      
      // context.of(Navigator).push();
      print('hello: $i');
      },);
    
    var m = {'/a': (ctx)=>Tna(fbtn: btn,), '/': (ctx)=>Tnb(fbtn: btn,)};
    return MaterialApp(initialRoute:'/', routes: m, );
  }
}

class Tna extends StatelessWidget {
  final FloatingActionButton fbtn;
  const Tna({Key key, this.fbtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var s=Scaffold(appBar: AppBar(),body: Text('hello a'),floatingActionButton: fbtn,);
    return s;
  }
}


class Tnb extends StatelessWidget {
  final FloatingActionButton fbtn;
  const Tnb({Key key, this.fbtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var s=Scaffold(appBar: AppBar(),body: Text('hello b'), floatingActionButton: fbtn,);
    return s;
  }
}
