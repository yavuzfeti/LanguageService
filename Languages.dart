import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kitx/Components/Themes.dart';
import 'package:kitx/Utils/Network.dart';
import 'package:kitx/main.dart';

// LanguageWidget(update:(){setState((){});},),
// Languages.takeLanguage();
// Languages.view(["Türkçe","İngilizce"]);

class Languages
{
  static List<String> languageCodes = ["tr", "en"];
  static List<String> languageLabels = ["Türkçe", "English"];

  static int code = 0;

  static void takeLanguage() async
  {
    String? localCode = await storage.read(key: "languageCode");
    if(localCode != null && localCode != "")
    {
      code = int.parse(localCode);
    }
    else if (window.locales.isNotEmpty && languageCodes.contains(window.locales.first.languageCode))
    {
      code = languageCodes.indexOf(window.locales.first.languageCode.toString());
    }
  }

  static void saveLanguage(String value) async
  {
    code = languageLabels.indexOf(value);
    await storage.write(key: "languageCode", value: code.toString());
    main();
  }

  static String view(List<String> words) => words.length > code ? words[code] : words[1];
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            style: TextStyle(
                fontSize: 18, color: Themes.mainColor, fontFamily: "SFUI"),
            Languages.view(["Dil","Language"])),
        SizedBox(
          width: 20,
        ),
        DropdownButton<String>(
          dropdownColor: Themes.back,
          style: TextStyle(fontSize: 18, color: Themes.front, fontFamily: "SFUI"),
          underline: Container(),
          value: Languages.languageLabels[Languages.code],
          onChanged: (value) async
          {
            Languages.saveLanguage(value!);
            widget.update?.call();
          },
          items: Languages.languageLabels.map((item)
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
