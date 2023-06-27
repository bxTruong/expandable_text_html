import 'package:expandable_text_html/expandable_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable Text Html Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Expandable text html'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const ExpandableTextHtml(
          """<p><span style="font-size:20px;"><strong>What Makes You Beautiful</strong></span></p><p><span style="font-size:12px;"><i>Bài hát của One Directio</i></span></p><p><span style="background-color:rgb(255,255,255);color:rgb(32,33,36);font-size:18px;">Lời bài hát</span></p><p style="margin-left:0px;">You're insecure, don't know what for<br>You're turning heads when you walk through the door<br>Don't need makeup to cover up<br>Being the way that you are is enough</p><p style="margin-left:0px;">Everyone else in the room can see it<br>Everyone else, but you, ooh</p><p style="margin-left:0px;">Baby, you light up my world like nobody else<br>The way that you flip your hair gets me overwhelmed<br>But when you smile at the ground, it ain't hard to tell<br>You don't know, oh-oh<br>You don't know you're beautiful</p><p style="margin-left:0px;">If only you saw what I can see<br>You'll understand why I want you so desperately<br>Right now I'm lookin' at you, and I can't believe</p><p style="margin-left:0px;">You don't know, oh-oh<br>You don't know you're beautiful, oh, oh-oh<br>That's what makes you beautiful</p><p style="margin-left:0px;">So c-come on, you got it wrong<br>To prove I'm right, I put it in a song<br>I don't know why you're being shy<br>And turn away when I look into your eyes</p><p style="margin-left:0px;">Everyone else in the room can see it<br>Everyone else, but you, ooh</p><p style="margin-left:0px;">Baby, you light up my world like nobody else<br>The way that you flip your hair gets me overwhelmed<br>But when you smile at the ground, it ain't hard to tell<br>You don't know, oh-oh<br>You don't know you're beautiful</p><p style="margin-left:0px;">If only you saw what I can see<br>You'll understand why I want you so desperately<br>Right now I'm lookin' at you, and I can't believe</p><p style="margin-left:0px;">You don't know, oh-oh<br>You don't know you're beautiful, oh, oh-oh<br>That's what makes you beautiful</p><p style="margin-left:0px;">Na-na-na, na-na-na, na, na, na<br>Na-na-na, na-na-na<br>Na-na-na, na-na-na, na, na, na<br>Na-na-na, na-na-na</p><p style="margin-left:0px;">Baby, you light up my world like nobody else<br>The way that you flip your hair gets me overwhelmed<br>But when you smile at the ground, it ain't hard to tell<br>(You don't know, oh-oh)<br>You don't know you're beautiful</p><p style="margin-left:0px;">Baby, you light up my world like nobody else<br>The way that you flip your hair gets me overwhelmed<br>But when you smile at the ground, it ain't hard to tell<br>You don't know, oh-oh<br>You don't know you're beautiful</p><p style="margin-left:0px;">If only you saw what I can see<br>You'll understand why I want you so desperately<br>Right now I'm lookin' at you, and I can't believe</p><p style="margin-left:0px;">You don't know, oh-oh<br>You don't know you're beautiful, oh, oh-oh<br>You don't know you're beautiful, oh, oh-oh<br>That's what makes you beautiful</p><p style="margin-left:0px;">Dịch sang Tiếng Việt</p><p><br>&nbsp;</p>""",
          maxLines: 3, expandText: 'Xem thêm', collapseText: 'Thu gọn'),
    );
  }
}
