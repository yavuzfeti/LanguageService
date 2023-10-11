import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitx/Components/Themes.dart';
import 'package:kitx/Utils/Network.dart';
import 'package:kitx/main.dart';

// supportedLocales: await Languages.supLocale(),
// locale: await Languages.locale(),
// await Languages.takeLanguage(languageFolderPath:"lib/Assets/Languages/",languageCodes: ["tr", "en", "de", "ru", "ar"]);
// LanguageWidget(update:(){setState((){});},),
// Languages.V["turkish"];

class Languages
{
  static int code = 0;
  static String path = "";
  static List<String> codes = [];
  static Map<String,dynamic> DEF = {};

  static String v (String word) => (DEF[word] ?? word).toString();

  static Future<void> takeLanguage({required String languageFolderPath, required List<String> languageCodes}) async
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
    DEF = await jsonDecode(await rootBundle.loadString("${path+codes[value]}.json"));
  }

  static Future<List<Locale>> supLocale() async
  {
    List<Locale> supLcl = [];
    for(String x in codes)
    {
      supLcl.add(Locale(x));
    }
    return supLcl;
  }
  
  static Future<Locale> locale() async => Locale(Languages.codes[Languages.code]);
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
          Languages.v("language"),
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
