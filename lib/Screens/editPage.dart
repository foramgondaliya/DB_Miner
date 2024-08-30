import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Color selBackGroundColor = Colors.black87;
  Color selFontColor = Colors.white;
  List<String> fontFamilies = GoogleFonts.asMap().keys.toList();
  double textSize = 17;
  FontWeight fontWeight = FontWeight.w500;
  double font = 5;
  late String selFont;
  String? selImage;
  double dx = 0;
  double dy = 0;
  GlobalKey repaintKey = GlobalKey();
  late String quote;
  late String author;

  @override
  void initState() {
    super.initState();
    selFont = fontFamilies[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    quote = args['quote'] ?? '';
    author = args['author'] ?? '';
  }

  Future<void> shareImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await renderRepaintBoundary.toImage(pixelRatio: 5);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List fetchImage = byteData!.buffer.asUint8List();
    Directory directory = await getApplicationCacheDirectory();
    String path = directory.path;
    File file = File('$path/quote_image.png');
    file.writeAsBytesSync(fetchImage);
    ShareExtend.share(file.path, "Image");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Quote"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selBackGroundColor = Colors.black87;
                selFontColor = Colors.white;
                textSize = 18;
                fontWeight = FontWeight.w500;
                font = 5;
                selFont = fontFamilies[0];
                selImage = null;
              });
            },
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await shareImage();
        },
        child: const Icon(Icons.share),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  RepaintBoundary(
                    key: repaintKey,
                    child: Stack(
                      children: [
                        Container(
                          height: 390,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:
                                (selImage == null) ? selBackGroundColor : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 242),
                                Text(
                                  quote,
                                  style: GoogleFonts.getFont(
                                    selFont,
                                    textStyle: TextStyle(
                                        fontSize: textSize,
                                        fontWeight: fontWeight,
                                        color: selFontColor),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "- $author",
                                      style: GoogleFonts.getFont(
                                        selFont,
                                        textStyle: TextStyle(
                                          fontSize: textSize,
                                          fontWeight: fontWeight,
                                          color: selFontColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView(
                children: [
                  Slider(
                    value: font,
                    min: 1,
                    max: 9,
                    divisions: 9,
                    onChanged: (val) {
                      setState(() {
                        font = val;
                        fontWeight = FontWeight.values[val.toInt() - 1];
                      });
                    },
                  ),
                  Slider(
                    value: textSize,
                    min: 15,
                    max: 20,
                    onChanged: (val) {
                      setState(() {
                        textSize = val;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Change Font Color",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: Colors.primaries
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selFontColor = e;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: e,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Change Background Color",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: Colors.accents
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selBackGroundColor = e;
                                        selImage = null;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: e,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
