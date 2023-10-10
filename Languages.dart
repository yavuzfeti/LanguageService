import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kitx/Components/Themes.dart';
import 'package:kitx/Utils/Network.dart';
import 'package:kitx/main.dart';

// Languages.takeLanguage();
// LanguageWidget(),
// Languages.view(["Türkçe","İngilizce"]);

class LanguageWidget extends StatefulWidget
{
  const LanguageWidget({super.key});

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
            "Dil"),
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
            setState(()
            {
              Languages.code;
            });
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

class Languages
{
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

  static String view(List<String> words) => words[code];

  static List<String> languageCodes = ["tr", "en"];
  static List<String> languageLabels = ["Türkçe", "English"];
}
