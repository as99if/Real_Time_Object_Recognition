import 'package:flutter/material.dart';


class LanguageListModel{

List<Widget> languageList;

LanguageListModel(){
  languageList = new List<Widget>();
  for (var item in langList) {
    languageList.add(Padding(
      padding: EdgeInsets.only(top: 3, bottom:3),
      child: Text(item['lang'])));
  }
}

final List<Map<String, String>> langList = [
  {'lang': 'Afrikaans', 'langCode': 'af'},
  {'lang': 'Albanian', 'langCode': 'sq'},
  {'lang': 'Arabic', 'langCode': 'hy'},
  {'lang': 'Armenian', 'langCode': 'af'},
  {'lang': 'Belarusian', 'langCode': 'be'},
  {'lang': 'Bengali', 'langCode': 'bn'},
  {'lang': 'Bosnian', 'langCode': 'bs'},
  {'lang': 'Bulgarian', 'langCode': 'bg'},
  {'lang': 'Catalan', 'langCode': 'ca'},
  {'lang': 'Chinese', 'langCode': 'zh'},
  {'lang': 'Corsican', 'langCode': 'co'},
  {'lang': 'Croatian', 'langCode': 'hr'},
  {'lang': 'Czech', 'langCode': 'cs'},
  {'lang': 'Danish', 'langCode': 'da'},
  {'lang': 'Dutch', 'langCode': 'nl'},
  {'lang': 'English', 'langCode': 'en'},
  {'lang': 'Esperanto', 'langCode': 'eo'},
  {'lang': 'Estonian', 'langCode': 'et'},
  {'lang': 'Finnish', 'langCode': 'fi'},
  {'lang': 'French', 'langCode': 'fr'},
  {'lang': 'Frisian', 'langCode': 'fy'},
  {'lang': 'Georgian', 'langCode': 'ka'},
  {'lang': 'German', 'langCode': 'de'},
  {'lang': 'Greek', 'langCode': 'el'},
  {'lang': 'Gujarati', 'langCode': 'gu'},
  {'lang': 'Hawaiian', 'langCode': 'haw'},
  {'lang': 'Hebrew', 'langCode': 'he'},
  {'lang': 'Hindi', 'langCode': 'hi'},
  {'lang': 'Hungarian', 'langCode': 'hu'},
  {'lang': 'Icelandic', 'langCode': 'is'},
  {'lang': 'Igbo', 'langCode': 'ig'},
  {'lang': 'Indonesian', 'langCode': 'id'},
  {'lang': 'Irish', 'langCode': 'ga'},
  {'lang': 'Italian', 'langCode': 'it'},
  {'lang': 'Japanese', 'langCode': 'ja'},
  {'lang': 'Javanese', 'langCode': 'jv'},
  {'lang': 'Kazakh', 'langCode': 'kk'},
  {'lang': 'Khmer', 'langCode': 'km'},
  {'lang': 'Korean', 'langCode': 'ko'},
  {'lang': 'Lao', 'langCode': 'lo'},
  {'lang': 'Latin', 'langCode': 'la'},
  {'lang': 'Latvian', 'langCode': 'lv'},
  {'lang': 'Lithuanian', 'langCode': 'lt'},
  {'lang': 'Luxembourgish', 'langCode': 'lb'},
  {'lang': 'Macedonian', 'langCode': 'mk'},
  {'lang': 'Malagasy', 'langCode': 'mg'},
  {'lang': 'Malay', 'langCode': 'ms'},
  {'lang': 'Malayalam', 'langCode': 'ml'},
  {'lang': 'Maltese', 'langCode': 'mt'},
  {'lang': 'Maori', 'langCode': 'mi'},
  {'lang': 'Marathi', 'langCode': 'mr'},
  {'lang': 'Mongolian', 'langCode': 'mn'},
  {'lang': 'Myanmar', 'langCode': 'my'},
  {'lang': 'Nepali', 'langCode': 'ne'},
  {'lang': 'Persian', 'langCode': 'fa'},
  {'lang': 'Polish', 'langCode': 'pl'},
  {'lang': 'Portuguese (Portugal, Brazil)', 'langCode': 'pt'},
  {'lang': 'Punjabi', 'langCode': 'pa'},
  {'lang': 'Romanian', 'langCode': 'ro'},
  {'lang': 'Russian', 'langCode': 'ru'},
  {'lang': 'Serbian', 'langCode': 'sr'},
  {'lang': 'Sindhi', 'langCode': 'sd'},
  {'lang': 'Slovak', 'langCode': 'sk'},
  {'lang': 'Slovenian', 'langCode': 'sl'},
  {'lang': 'Somali', 'langCode': 'so'},
  {'lang': 'Spanish', 'langCode': 'es'},
  {'lang': 'Sundanese', 'langCode': 'su'},
  {'lang': 'Swedish', 'langCode': 'sv'},
  {'lang': 'Tagalog (Filipino)', 'langCode': 'tl'},
  {'lang': 'Tamil', 'langCode': 'ta'},
  {'lang': 'Telugu', 'langCode': 'te'},
  {'lang': 'Thai', 'langCode': 'th'},
  {'lang': 'Turkish', 'langCode': 'tr'},
  {'lang': 'Ukrainian', 'langCode': 'uk'},
  {'lang': 'Urdu', 'langCode': 'ur'},
  {'lang': 'Uzbek', 'langCode': 'uy'},
  {'lang': 'Vietnamese', 'langCode': 'vi'},
  {'lang': 'Welsh', 'langCode': 'cy'},
  {'lang': 'Yoruba', 'langCode': 'yo'},
  {'lang': 'Zulu', 'langCode': 'zu'},
];
}

/*
Afrikaans	af
Albanian	sq

Arabic	ar
Armenian	hy


Belarusian	be
Bengali	bn
Bosnian	bs
Bulgarian	bg
Catalan	ca

Chinese (Simplified)	zh-CN or zh (BCP-47)

Corsican	co
Croatian	hr
Czech	cs
Danish	da
Dutch	nl
English	en
Esperanto	eo
Estonian	et
Finnish	fi
French	fr
Frisian	fy

Georgian	ka
German	de
Greek	el
Gujarati	gu

Hawaiian	haw (ISO-639-2)
Hebrew	he or iw
Hindi	hi

Hungarian	hu
Icelandic	is
Igbo	ig
Indonesian	id
Irish	ga
Italian	it
Japanese	ja
Javanese	jv

Kazakh	kk
Khmer	km
Korean	ko


Lao	lo
Latin	la
Latvian	lv
Lithuanian	lt
Luxembourgish	lb
Macedonian	mk
Malagasy	mg
Malay	ms
Malayalam	ml
Maltese	mt
Maori	mi
Marathi	mr
Mongolian	mn
Myanmar (Burmese)	my
Nepali	ne
Norwegian	no


Persian	fa
Polish	pl
Portuguese (Portugal, Brazil)	pt
Punjabi	pa
Romanian	ro
Russian	ru


Serbian	sr


Sindhi	sd

Slovak	sk
Slovenian	sl
Somali	so
Spanish	es
Sundanese	su

Swedish	sv
Tagalog (Filipino)	tl

Tamil	ta
Telugu	te
Thai	th
Turkish	tr
Ukrainian	uk
Urdu	ur
Uzbek	uz
Vietnamese	vi
Welsh	cy


Yoruba	yo
Zulu	zu
*/
