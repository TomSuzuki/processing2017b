//起動画面
int SartPosY = 0, StratTime = 0;
String NowEventList = "";
void MasterStart() {
  //処理
  if (mouseKey == 0) SartPosY = SartPosY - int(easing(SartPosY, 640, -2, 12, 2)*frameRateSpeed);
  else SartPosY = SartPosY + (mouseY - pmouseY);
  if (SartPosY > 0) SartPosY = 0;
  if (SartPosY < -520) MasterFlg = -3;
  StratTime = 0;

  if (SubCount == 0) {
    NowHomeworkList = "";
    NowEventList = "";
    if (MasterFlg == -2) {//ロード完了してから
      int num = 0;
      for (int i = 0; i < ScheduleDate.length; i++) if ((yesterday(ScheduleDate[i]).equals(year()+"/"+month()+"/"+day()) || ScheduleDate[i].equals(year()+"/"+month()+"/"+day())) && SchedulePercent[i] != 1) num = num + 1;
      if (num == 0) NowHomeworkList = "明日までの課題はありません。";
      else NowHomeworkList = "明日までの未完了課題が"+num+"件あります。";

      num = 0;
      for (int i = 0; i < EventDate.length; i++) if ((yesterday(EventDate[i]).equals(year()+"/"+month()+"/"+day()) || EventDate[i].equals(year()+"/"+month()+"/"+day()))) num = num + 1;
      if (num == 0) NowEventList = "明日までのイベントはありません。";
      else NowEventList = "明日までのイベントが"+num+"件あります。";
    }
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  int n = -SartPosY*5/640;
  if (n < 0) n = 0;
  else if (n > 4) n = 4;
  image(ImgBackgroundSub2[n], 0, 0);

  //スライド
  translate(0, SartPosY);

  //天気予報
  textSet(Font002, 16, LEFT, TOP);
  if (GetWeatherCityName.equals("") == false) ftextb(GetWeatherMsg[0]+" （"+GetWeatherCityName+"）" ,20 ,15, TextColor[1], TextColor[0]);

  //時計
  textSet(Font002, 64, LEFT, TOP);
  ftextb(nf(hour(), 2)+":"+nf(minute(), 2), 20, 470, TextColor[1], TextColor[0]);
  textSet(Font002, 32, LEFT, TOP);
  ftextb(month()+"月"+day()+"日  "+WeekDay2[dayweek(year(), month(), day())]+"曜日", 20, 540, TextColor[1], TextColor[0]);

  //課題
  textSet(Font002, 16, RIGHT, BOTTOM);
  ftextb(NowHomeworkList+"\n"+NowEventList, 460, 625, TextColor[1], TextColor[0]);

  //スライド
  translate(0, -SartPosY);

  //処理
  if (MasterFlg == 1) SartPosY = 0;
}