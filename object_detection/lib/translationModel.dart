
class TranlatedModel{
  String code;
  String lang;
  String text;

  TranlatedModel.fromList(Map json) {
    this.code = json["code"];
    this.lang = json["lang"];
    this.text = json["text"];
  }
}