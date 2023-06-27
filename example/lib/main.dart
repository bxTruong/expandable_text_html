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
      body: const ExpandableTextHtml("""
      <body>
    <h1 style='color: black; font-size:50px; font-style:italic; 
    background-color: rgb(0,122,255); font-weight:100;)'> Hello word! </h1>
    <h1 style=''>Convert your <span style='color:lightseagreen;'>
    HTML</span> and <span style='color:dodgerblue'>CSS</span> 
    easily into RichText</h1>
    <p>Lorem ipsum dolor sit, consectetur adipiscing elit. Pellentesque in leo 
    id dui bibendum fringilla in et arcu. In vehicula vel est sed mattis.</p>
    <p><a href="https://google.com">Need more? click this link</a></p>
    <p>We all spell <span style='color:crimson; 
    text-decoration: underline wavy;'>recieve</span> wrong.<br />Some times we 
    delete <del>stuff</del></p>
    <div style='font-size:17px'>We write things that are 
    <span style='font-size:1.5em;'>Big,</span> <b>bold</b>&nbsp; or 
    <span style='color:brown'>colorful</span></div>
    <p style='font-family:times;'>Some different FONT with 
    <span style='background-color:lightcyan;'>this part highlighted</span></p>
    <div style='line-height:2; font-size:17px;'><b style='color: rgb(0,122,255); 
    font-weight:500;'>Finally some line heights.</b> Lorem ipsum dolor sit amet, 
    consectetur adipiscing elit. Pellentesque in leo id dui bibendum fringilla 
    in et arcu. In vehicula vel est sed mattis. Duis varius, sem non mattis.</div>
</body>
""", maxLines: 3, expandText: 'Xem thêm', collapseText: 'Thu gọn'),
    );
  }
}
