//天気予報
String GetWeatherBaseURL = "http://weather.livedoor.com/forecast/webservice/json/v1?city=";
String GetWeatherCity = "";
String GetWeatherCityName = "";
String GetWeatherNowWeather = "";
String GetWeatherMsgAll = "";
String GetWeatherNowTemperature = "";
String[] GetWeatherMsg = {""};
processing.data.JSONArray forecasts;

//天気を取得する
void GetWeather() {
  MakeFileNoFile(GetWeatherPass, "");
  String a[] = loadStrings(GetWeatherPass);
  String b[] = split(a[0], ",");
  GetWeatherCity = b[0];
  if (b.length > 1) GetWeatherCityName = b[1];
  GetWeatherMsgAll = "";
  GetWeatherMsg = new String[3];
  for (int i = 0; i < GetWeatherMsg.length; i++) GetWeatherMsg[i] = "";
  GetWeatherMsg[0] = "#ERROR";
  GetWeatherNowWeather = "#ERROR";
  GetWeatherNowTemperature = "#ERROR";

  try {//オフラインだったら取得できないのでその対策
    processing.data.JSONObject w = loadJSONObject(GetWeatherBaseURL + GetWeatherCity);
    forecasts = w.getJSONArray("forecasts");
    for (int i = 0; i < min(forecasts.size(), 3); i++) {
      GetWeatherMsg[i] = "";
      processing.data.JSONObject f = forecasts.getJSONObject(i);
      processing.data.JSONObject t = f.getJSONObject("temperature");
      if (i == 0) {
        GetWeatherNowWeather = f.getString("telop");
        if (!t.isNull("min")) GetWeatherNowTemperature = t.getJSONObject("min").getString("celsius")+"度　｜　";
        else GetWeatherNowTemperature = "--度　｜　";
        if (!t.isNull("max")) GetWeatherNowTemperature += t.getJSONObject("max").getString("celsius")+"度";
        else GetWeatherNowTemperature += "--度";
      }
      GetWeatherMsg[i] += f.getString("dateLabel")+"の天気は、"+f.getString("telop");
      if (!t.isNull("temp")) GetWeatherMsg[i] += "、現在の気温は"+t.getJSONObject("temp").getString("celsius")+"度";
      //if (!t.isNull("max")) GetWeatherMsg[i] += "、最高気温は"+t.getJSONObject("max").getString("celsius")+"度";
      //if (!t.isNull("min")) GetWeatherMsg[i] += "、最低気温は"+t.getJSONObject("min").getString("celsius")+"度";
      GetWeatherMsg[i] += "です。";
      GetWeatherMsgAll = GetWeatherMsgAll + GetWeatherMsg[i] + "\n";
    }
    //println(GetWeatherMsg[i]);
  } 
  catch(Exception e) {
    for (int i = 0; i < GetWeatherMsg.length; i++) GetWeatherMsg[i] = "";
    GetWeatherMsg[0] = "#ERROR";
    GetWeatherNowWeather = "#ERROR";
    GetWeatherNowTemperature = "#ERROR";
  }
}

//地域選択画面
int SelectWeatherScroll = 0;
String NextCityID = null;
String NextCityName = null;
ArrayList<CityList> ArrayCityList;
void SelectWeather() {
  //初期化
  if (SubCount == 0) {
    Img000 = ImgBackground.get(0, 0, 480, 72);
    mouseKey = 0;
    NextCityID = null;
    SelectWeatherScroll = 0;
    MakeFileNoFile(GetWeatherList, "");
    String[] a = loadStrings(GetWeatherList);
    ArrayCityList = new ArrayList<CityList>();
    for (String b : a) {
      String[] d = split(b, ",");
      if (d.length > 1) {
        CityList c = new CityList(d[0], d[1]);
        ArrayCityList.add(c);
      }
    }
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //スクロール処理
  if (mouseKey != 0 && 1 < abs(pmouseY - mouseY)) mouseKey = 3;
  if (mouseKey == 3) SelectWeatherScroll = SelectWeatherScroll + (mouseY - pmouseY);
  if (SelectWeatherScroll < 320-pPosY) SelectWeatherScroll = 320-pPosY;
  if (SelectWeatherScroll > 0) SelectWeatherScroll = 0;

  //描画
  int PosY = 72 + SelectWeatherScroll;
  if (mouseKey == 3) NextCityID = null;
  if (mouseKey == 0 && NextCityID != null) {
    MasterFlg = 5;//ここに定数使いたくない
    String[] a = {NextCityID+","+NextCityName};
    saveStrings(GetWeatherPass, a);
    GetWeather();
  }
  for (CityList CityData : ArrayCityList) {
    CityData.DrawBar(PosY);
    PosY = PosY + 72;
  }
  pPosY = PosY - SelectWeatherScroll;

  //キャンセル
  image(Img000, 0, 0);
  frect(0, 0, 480, 64, MainColor, 255);
  if (SingleButton("キャンセル", 0)) MasterFlg = 5;
}

//地域のクラス（classの練習として）
class CityList {
  String CityName = "";
  String CityID = "";

  //コンストラクタ
  CityList(String p1, String p2) {
    CityID = p1;
    CityName = p2;
  }

  //バーの表示と選択処理
  void DrawBar(int y) {
    if (blimt(mouseX, 1, 479) && blimt(mouseY, y+1, y+71) && mouseY > 72) {
      frect(1, y+1, width-2, 70, BarColor, FillAlphaSub);
      if (mouseKey == 1) {
        NextCityID = CityID;
        NextCityName = CityName;
      }
    } else frect(1, y+1, width-2, 70, BarColor, FillAlpha);
    textSet(Font001, 24, LEFT, TOP);
    ftextb(CityName, 20, y+20, TextColor[1], TextColor[0]);
  }
}

//詳細天気予報画面
void MasterWeather() {

  //更新
  if (SubCount == 0) {
    Img000 = ImgBackground.get(0, 0, 480, 143);
    GetWeather();
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //表示
  frect2(30, 150, 420, 140, MainColor, FillAlpha, 12);
  textSet(Font001, 48, CENTER, CENTER);
  ftextb(GetWeatherNowWeather, 240, 192, TextColor[1], TextColor[0]);
  textSet(Font001, 18, CENTER, CENTER);
  ftextb(GetWeatherNowTemperature, 240, 260, TextColor[1], TextColor[0]);
  frect2(20, 460, 440, 150, BarColor, FillAlpha, 12);
  textSet(Font002, 18, LEFT, TOP);
  ftextb2(GetWeatherMsgAll, 40, 480, TextColor[1], TextColor[0], 560, 480);

  //上部文字盤
  if (CalendarMainNowTab != 3) image(Img000, 0, 0);
  frect(2, 2, 476, 70, SubColor, FillAlphaSub);
  textSet(Font001, 24, LEFT, TOP);
  ftextb(GetWeatherCityName, 72, 20, TextColor[1], TextColor[0]);

  //セレクトタブボタン（関数化しよう？）
  if (mouseX > 10 && mouseX < 58 && mouseY > 10 && mouseY < 58) {
    tint(255);
    if (mouseKey == 1) ResetSelect(); 
    mouseKey = (mouseKey == 1) ? 2 : mouseKey;
  } else tint(128);
  image(Img002, 10, 10);
}