# [**Based on expandable_text**](https://pub.dev/packages/expandable_text)

![example expandable_text_html](https://imgur.com/gallery/fkK9jna)

### Installation

Add the following dependencies in your pubspec.yaml file of your flutter project.

```dart
    expandable_text_html: <latest_version>
```

### How to use


```dart 
import 'package:flutter/material.dart';
import 'package:expandable_text_html/expandable_text.dart';

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
```