import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// flutter_secure_storage: ^8.0.0

final storage = FlutterSecureStorage();

class Languages
{
  static int language = 0;

  static void selectLanguage() async
  {
    String? code = await storage.read(key: "languageCode");
    if(code != null && code != "")
    {
      language = int.parse(code);
    }
    else if (window.locales.isNotEmpty && languages.contains(window.locales.first.languageCode))
    {
      language = languages.indexOf(window.locales.first.languageCode.toString());
    }
  }

  static String view(List<String> words) => words[language];

  static List<String> languages = ["tr", "en", "de", "es"];

  static List<String> mrb = ["Merhaba", "Hello", "Hallo", "Hola"];
  static List<String> hosgeldiniz = ["Hoşgeldiniz", "Welcome", "Willkommen", "Bienvenido"];
  static List<String> gunaydin = ["Günaydın", "Good morning", "Guten Morgen", "Buenos días"];
  static List<String> iyiGeceler = ["İyi geceler", "Good night", "Gute Nacht", "Buenas noches"];
  static List<String> hoscaKal = ["Hoşçakal", "Goodbye", "Auf Wiedersehen", "Adiós"];
  static List<String> tesekkur = ["Teşekkür ederim", "Thank you", "Danke", "Gracias"];
  static List<String> lutfen = ["Lütfen", "Please", "Bitte", "Por favor"];
  static List<String> affedersiniz = ["Affedersiniz", "Excuse me", "Entschuldigung", "Perdón"];
  static List<String> evet = ["Evet", "Yes", "Ja", "Sí"];
}

