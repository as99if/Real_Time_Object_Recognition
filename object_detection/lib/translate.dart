import 'dart:convert';

import 'package:flutter/material.dart';

import 'header.dart';
import 'package:http/http.dart' show Client;

class Translate{
  final String lang;
  String url;
  String translated_text='';

  Translate({this.lang});
  
  Client client = Client();
  Future<String> getTranslation(String text) async {
    url = "https://${getBaseUrl()}translate?key=${getApiKey()}&text=$text&lang=$lang";
    final response = await client.get(url);
    if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData['text'][0];
      } else {
        //return null;
        throw Exception("Failed to get");
      }
  }

  String translate(String text){
    getTranslation(text).then((String result){
      debugPrint(result);
      translated_text = result;
    });
    return translated_text;
  }
  

}