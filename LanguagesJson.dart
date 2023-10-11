import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitx/Components/Themes.dart';
import 'package:kitx/Utils/Network.dart';
import 'package:kitx/main.dart';

// LanguageWidget(update:(){setState((){});},),
// Languages.takeLanguage(languageFolderPath:"lib/Assets/Languages/",languageCodes: ["tr", "en", "de", "ru", "ar"]);
// Languages.V["turkish"];

class Languages
{
  static int code = 0;
  static String path = "";
  static List<String> codes = [];
  static Map V = {};

  static void takeLanguage({required String languageFolderPath, required List<String> languageCodes}) async
  {
    path = languageFolderPath;
    codes = languageCodes;
    String? localCode = await storage.read(key: "languageCode");
    if(localCode != null && localCode != "")
    {
      changeLanguage(int.parse(localCode));
    }
    else if (window.locales.isNotEmpty && languageCodes.contains(window.locales.first.languageCode))
    {
      changeLanguage(languageCodes.indexOf(window.locales.first.languageCode.toString()));
    }
    else
    {
      changeLanguage(languageCodes.indexOf("en"));
    }
  }

  static void saveLanguage(int value) async
  {
    changeLanguage(value);
    await storage.write(key: "languageCode", value: value.toString());
    main();
  }

  static void changeLanguage(int value) async
  {
    code = value;
    V = await jsonDecode(await rootBundle.loadString("${path+codes[value]}.json"));
  }
}

class LanguageWidget extends StatefulWidget
{
  final VoidCallback? update;
  const LanguageWidget({super.key,required this.update});

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget>
{
  @override
  void initState(){
    super.initState();
    takeLanguageData();
  }

  bool loading = true;
  List<String> languageLabels = [];

  Future<void> takeLanguageData() async
  {
    languageLabels = [];
    for(String lanCode in Languages.codes)
    {
      languageLabels.add(await jsonDecode((await rootBundle.loadString("${Languages.path+lanCode}.json")))["languageLabel"]);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${Languages.V["language"]}",
          style: TextStyle(fontSize: 18, color: Themes.mainColor, fontFamily: "SFUI"),
        ),
        SizedBox(
          width: 20,
        ),
        DropdownButton<String>(
          dropdownColor: Themes.back,
          style: TextStyle(fontSize: 18, color: Themes.front, fontFamily: "SFUI"),
          underline: Container(),
          value: languageLabels[Languages.code],
          onChanged: (value) async
          {
            Languages.saveLanguage(languageLabels.indexOf(value!));
            widget.update?.call();
          },
          items: languageLabels.map((item)
          {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(style: TextStyle(fontSize: 18, color: Themes.front, fontFamily: "SFUI"),item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
