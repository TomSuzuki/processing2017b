String SettingHomeworkSubject = "";
String SettingHomeworkMemo = "";
String SettingHomeworkpData = "";
int SettingHomeworkFlg = 0;
int SettingHomeworkHour = 0;
int SettingHomeworkMinute = 0;
int SettingHomeworkDay = 0;
int SettingHomeworkMonth = 0;
int SettingHomeworkYear = 1990;
float SettingHomeworkStudyTime = 0;
float SettingHomeworkPar = 0;

//課題設定画面
void MasterSettingHomework() {
  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //キャンセル||完了
  switch(CompleteButton(SettingHomeworkSubject.equals("")==false)) {
  case 1://キャンセル
    MasterFlg = BeforeFlg;
    break;
  case 2://完了
    if (SettingHomeworkFlg == 1) DelLine2(FileDataSchedule, SettingHomeworkpData);//修正の部分
    SettingHomeworkpData = (SettingHomeworkYear+"/"+SettingHomeworkMonth+"/"+SettingHomeworkDay)+","+(SettingHomeworkHour+":"+SettingHomeworkMinute)+","+SettingHomeworkSubject+","+SettingHomeworkPar+","+SettingHomeworkStudyTime+","+SettingHomeworkMemo;
    AddLine(FileDataSchedule, SettingHomeworkpData);//新規作成
    LoadSchedule(FileDataSchedule);   //スケジュールのリロード
    if (SettingHomeworkPar == 1.0) {
      MasterFlg = 40;
    } else {
      MasterFlg = BeforeFlg;
    }
    break;
  }

  //日付
  Date(12, 180, SettingHomeworkYear, SettingHomeworkMonth, SettingHomeworkDay);

  //時計
  Clock(96, 356, SettingHomeworkHour, SettingHomeworkMinute);

  //メモ
  if (KeyBodeUpDate.equals("") == false) {
    SettingHomeworkMemo = KeyBodeUpDate.substring(1, KeyBodeUpDate.length()).replaceAll( "\n", "%n");
    KeyBodeUpDate = "";
  }
  Memo(SettingHomeworkMemo, 220, 180);

  //科目
  if (mouseX > 1 && mouseX < 479 && mouseY > 67 && mouseY < 137) {
    frect(1, 67, 478, 70, MainColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      SubjectUpDate = "";
      SubjectSelect = -1;
      BeforeFlgSubject = MasterFlg;
      MasterFlg = 12;
      SubjectFlg = 1;
    }
  }
  if (SubjectUpDate.equals("") == false) {
    SettingHomeworkSubject = SubjectUpDate;
    SubjectUpDate = "";
  }
  BarSubject(SettingHomeworkSubject, 66, SettingHomeworkPar, "", "");
  if (SettingHomeworkSubject.equals("")) {
    textSet(Font001, 24, LEFT, TOP);
    ftextb("科目を選択してください", 40, 66+15, TextColor[1], TextColor[0]);
  }

  //達成度バー（ここでしか使わないので関数化はしない）
  float BarX = 40.0 + 400.0 * SettingHomeworkPar;
  //縁
  fellipse(40, 564-48, 16, 16, MainColor, 255);
  fellipse(440, 564-48, 16, 16, MainColor, 255);
  frect(40, 560-48, 400, 8, MainColor, 255);
  //中
  fellipse(40, 564-48, 12, 12, TextColor[0], 255);
  fellipse(440, 564-48, 12, 12, TextColor[0], 255); 
  frect(40, 562-48, 400, 4, TextColor[0], 255);
  //上
  fellipse(40, 564-48, 12, 12, SubColor, 255);
  fellipse(BarX, 564-48, 12, 12, SubColor, 255);
  frect(40, 562-48, BarX-40, 4, SubColor, 255);
  //マウス
  if (mouseKey == 1 && dist(mouseX, mouseY, BarX, 564-48) < 28) mouseKey = 3;
  if (mouseKey == 3) {
    BarX = mouseX;
    if (BarX < 40) BarX = 40;
    if (BarX > 440) BarX = 440;
    SettingHomeworkPar = (BarX - 40.0) / 400.0;
  }
  if (mouseKey == 3 || dist(mouseX, mouseY, BarX, 564-48) < 28) {    
    fellipse(40, 564-48, 12, 12, TextColor[1], 255);
    fellipse(BarX, 564-48, 16, 16, MainColor, 255); 
    fellipse(BarX, 564-48, 12, 12, TextColor[1], 255);
    frect(40, 562-48, BarX-40, 4, TextColor[1], 255);
  }
  //テキスト
  textSet(Font001, 36, LEFT, TOP);
  ftextb(int(SettingHomeworkPar*100)+"%", 40, 500-48, TextColor[1], TextColor[0]);

  //削除
  if (SettingHomeworkFlg == 1) {
    if (SingleButton("削除", 576)) {
      DelLine2(FileDataSchedule, SettingHomeworkpData);
      LoadSchedule(FileDataSchedule);   //スケジュールのリロード
      MasterFlg = BeforeFlg;
    }
  }

  //ツイートボタン
  if (SubCount == 0) tFlg = true;
  TweetButton(350, 450, "#tom_scheduler "+(SettingHomeworkYear+"/"+nf(SettingHomeworkMonth, 2)+"/"+nf(SettingHomeworkDay, 2))+" "+(nf(SettingHomeworkHour, 2)+":"+nf(SettingHomeworkMinute, 2)) +"までの"+SettingHomeworkSubject+"の課題があります。（"+SettingHomeworkMemo+"）", tFlg);
}

//課題設定画面初期化（新規作成）
void MasterSettingHomeworkReset() {
  SettingHomeworkSubject = "";
  SettingHomeworkFlg = 0;
  SettingHomeworkHour = hour();
  SettingHomeworkMinute = minute();
  SettingHomeworkDay = SelectDay;
  SettingHomeworkMonth = SelectMonth;
  SettingHomeworkYear = SelectYear;
  SettingHomeworkMemo = "";
  SettingHomeworkPar = 0;
  SettingHomeworkStudyTime = 0;
}

//年を選択する
int SelectYearYear = 0;
void MasterSelectYear() {
  //背景
  background(0);
  tint(64);
  image(Img000, 0, 0);

  //キャンセル||完了
  switch(CompleteButton(true)) {
  case 1://キャンセル
    MasterFlg = BeforeFlg2;
    break;
  case 2://完了
    SettingHomeworkYear = SelectYearYear;
    MasterFlg = BeforeFlg2;
    break;
  }

  //メイン描画
  if (mouseX > 180 && mouseX < 300 && mouseY > 312-80 && mouseY < 312-80+32) {
    frect(180, 312-80, 120, 32, BarColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectYearYear = SelectYearYear - 1;
    }
  } else frect(180, 312-80, 120, 32, BarColor, FillAlpha);
  if (mouseX > 180 && mouseX < 300 && mouseY > 312+48 && mouseY < 312+48+32) {
    frect(180, 312+48, 120, 32, BarColor, FillAlphaSub);    
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectYearYear = SelectYearYear + 1;
    }
  } else frect(180, 312+48, 120, 32, BarColor, FillAlpha);
  frect(80, 280, 320, 64, BarColor, FillAlphaSub);
  textSet(Font001, 48, CENTER, CENTER);
  ftextb(SelectYearYear+"年", 240, 312, TextColor[1], TextColor[0]);
  textSet(Font001, 24, CENTER, CENTER);
  ftextb((SelectYearYear-1)+"年", 240, 312-64, TextColor[2], TextColor[0]);
  ftextb((SelectYearYear+1)+"年", 240, 312+64, TextColor[2], TextColor[0]);

  //処理
  if (abs(mouseY - pmouseY) > 1 && mouseKey == 1) mouseKey = 3;
  if (mouseKey == 3) SelectYearYear = SelectYearYear + (mouseY - pmouseY)/5;
}

//月日を選択する
int SelectDateDay = 1;
int SelectDateMonth = 1;
void MasterSelectDate() {
  //背景
  background(0);
  tint(64);
  image(Img000, 0, 0);

  //キャンセル||完了
  switch(CompleteButton(true)) {
  case 1://キャンセル
    MasterFlg = BeforeFlg2;
    break;
  case 2://完了
    SettingHomeworkDay = SelectDateDay;
    SettingHomeworkMonth = SelectDateMonth;
    MasterFlg = BeforeFlg2;
    break;
  }

  //メイン描画
  if (mouseY > 312-80 && mouseY < 312-80+32 && mouseX > 100 && mouseX < 220) {
    frect(100, 312-80, 120, 32, BarColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey =2; 
      SelectDateMonth = SelectDateMonth - 1;
    }
  } else frect(100, 312-80, 120, 32, BarColor, FillAlpha);
  if (mouseY > 312-80 && mouseY < 312-80+32 && mouseX > 260 && mouseX < 380) {
    frect(260, 312-80, 120, 32, BarColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey =2; 
      SelectDateDay = SelectDateDay - 1;
    }
  } else frect(260, 312-80, 120, 32, BarColor, FillAlpha);
  if (mouseY > 312+48 && mouseY < 312+48+32 && mouseX > 100 && mouseX < 220) {
    frect(100, 312+48, 120, 32, BarColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey =2; 
      SelectDateMonth = SelectDateMonth + 1;
    }
  } else frect(100, 312+48, 120, 32, BarColor, FillAlpha);
  if (mouseY > 312+48 && mouseY < 312+48+32 && mouseX > 260 && mouseX < 380) {
    frect(260, 312+48, 120, 32, BarColor, FillAlphaSub);  
    if (mouseKey == 1) {
      mouseKey =2; 
      SelectDateDay = SelectDateDay + 1;
    }
  } else frect(260, 312+48, 120, 32, BarColor, FillAlpha);

  if (SelectDateMonth > 12) SelectDateMonth = 1;
  if (SelectDateMonth < 1) SelectDateMonth = 12;
  if (SelectDateDay < 1) SelectDateDay = getDays(SelectYearYear, SelectDateMonth);
  if (SelectDateDay > getDays(SelectYearYear, SelectDateMonth)) SelectDateDay = 1;
  frect(90, 280, 140, 64, BarColor, FillAlphaSub);
  frect(250, 280, 140, 64, BarColor, FillAlphaSub);
  textSet(Font001, 48, CENTER, CENTER);
  ftextb(SelectDateDay+"日", 320, 312, TextColor[1], TextColor[0]);
  ftextb(SelectDateMonth+"月", 160, 312, TextColor[1], TextColor[0]);
  textSet(Font001, 24, CENTER, CENTER);
  ftextb((SelectDateDay+getDays(SelectYearYear, SelectDateMonth)-2)%getDays(SelectYearYear, SelectDateMonth)+1+"日", 320, 312-64, TextColor[2], TextColor[0]);
  if (getDays(SelectYearYear, SelectDateMonth) == SelectDateDay) ftextb("1日", 320, 312+64, TextColor[2], TextColor[0]);//あまり使えばif文なんていらないんだけどなぁ
  else ftextb((SelectDateDay+1)+"日", 320, 312+64, TextColor[2], TextColor[0]);
  ftextb((SelectDateMonth+10)%12+1+"月", 160, 312-64, TextColor[2], TextColor[0]);
  ftextb((SelectDateMonth)%12+1+"月", 160, 312+64, TextColor[2], TextColor[0]);
  ftextb(SelectYearYear+"年"+SelectDateMonth+"月"+SelectDateDay+"日"+"（"+WeekDay2[dayweek(SelectYearYear, SelectDateMonth, SelectDateDay)]+"）", 240, 480, TextColor[1], TextColor[0]);
}

//時計
int SelectClockHour = 0;
int SelectClockMinute = 0;
int mouseFlg = 0, Select12Flg = 0;
String[] SelectAMPM = {"a.m.", "p.m."};
void MasterClock() {
  //背景
  background(0);
  tint(64);
  image(Img000, 0, 0);

  //キャンセル||完了
  switch(CompleteButton(true)) {
  case 1://キャンセル
    MasterFlg = BeforeFlg2;
    break;
  case 2://完了
    SettingHomeworkMinute = SelectClockMinute;
    SettingHomeworkHour = SelectClockHour + 12*Select12Flg;
    MasterFlg = BeforeFlg2;
    break;
  }

  //時計板背景
  textSet(Font001, 24, CENTER, CENTER);
  fellipse(240, 320, 400, 400, BarColor, FillAlphaSub);
  ftextb("60", 240, 320-180, TextColor[1], TextColor[0]);
  ftextb("30", 240, 320+180, TextColor[1], TextColor[0]);
  ftextb("15", 240+180, 320, TextColor[1], TextColor[0]);
  ftextb("45", 240-180, 320, TextColor[1], TextColor[0]);
  ftextb("12", 240, 320-100, TextColor[1], TextColor[0]);
  ftextb("6", 240, 320+100, TextColor[1], TextColor[0]);
  ftextb("3", 240+100, 320, TextColor[1], TextColor[0]);
  ftextb("9", 240-100, 320, TextColor[1], TextColor[0]);

  //選択中
  if (mouseFlg%10 == 2) ftextb(str((SelectClockHour+11)%12+1), 240+100*sin(radians(18-SelectClockHour)*360/12), 320+100*cos(radians(18-SelectClockHour)*360/12), TextColor[0], TextColor[1]);
  else ftextb(str((SelectClockHour+11)%12+1), 240+100*sin(radians(18-SelectClockHour)*360/12), 320+100*cos(radians(18-SelectClockHour)*360/12), MainColor, TextColor[0]);
  if (mouseFlg%10 == 1) ftextb(str((SelectClockMinute+59)%60+1), 240+180*sin(radians(90-SelectClockMinute)*360/60), 320+180*cos(radians(90-SelectClockMinute)*360/60), TextColor[0], TextColor[1]);
  else ftextb(str((SelectClockMinute+59)%60+1), 240+180*sin(radians(90-SelectClockMinute)*360/60), 320+180*cos(radians(90-SelectClockMinute)*360/60), MainColor, TextColor[0]);

  //時計の針とか
  strokeWeight(6);
  fline(240, 320, 240+180*sin(radians((90-SelectClockMinute)*360/60)), 320+180*cos(radians((90-SelectClockMinute)*360/60)), TextColor[0], 255);
  strokeWeight(3);
  if (mouseFlg%10 == 1) fline(240, 320, 240+180*sin(radians((90-SelectClockMinute)*360/60)), 320+180*cos(radians((90-SelectClockMinute)*360/60)), TextColor[1], 255);
  else fline(240, 320, 240+180*sin(radians((90-SelectClockMinute)*360/60)), 320+180*cos(radians((90-SelectClockMinute)*360/60)), MainColor, 255);
  strokeWeight(6);
  fline(240, 320, 240+100*sin(radians((18-SelectClockHour)*360/12)), 320+100*cos((radians(18-SelectClockHour)*360/12)), TextColor[0], 255);
  strokeWeight(3);
  if ( mouseFlg%10 == 2) fline(240, 320, 240+100*sin(radians((18-SelectClockHour)*360/12)), 320+100*cos((radians(18-SelectClockHour)*360/12)), TextColor[1], 255);
  else fline(240, 320, 240+100*sin(radians((18-SelectClockHour)*360/12)), 320+100*cos((radians(18-SelectClockHour)*360/12)), MainColor, 255);
  noStroke();

  //選択
  if (mouseKey == 0 || mouseFlg < 10) mouseFlg = 0;
  //時間
  if (dist(mouseX, mouseY, 240+180*sin(radians((90-SelectClockMinute)*360/60)), 320+180*cos(radians((90-SelectClockMinute)*360/60))) < 24) {
    if (mouseFlg == 0) mouseFlg = 1;
    if (mouseKey == 1) {
      mouseKey = 3;
      mouseFlg = 11;
    }
  }
  if (mouseFlg == 11) SelectClockMinute = (180-int(degrees(atan2(mouseX-240, mouseY-360))))*60/360+1;//ずれてる
  SelectClockMinute = SelectClockMinute % 60;
  //分
  if (dist(mouseX, mouseY, 240+100*sin(radians((18-SelectClockHour)*360/12)), 320+100*cos(radians((18-SelectClockHour)*360/12))) < 24) {
    if (mouseFlg == 0) mouseFlg = 2;
    if (mouseKey == 1) {
      mouseKey = 3;
      mouseFlg = 12;
    }
  }
  if (mouseFlg == 12) SelectClockHour = (180-int(degrees(atan2(mouseX-240, mouseY-360))))*12/360+1;//ずれてる
  SelectClockHour = SelectClockHour % 12;

  //デジタル
  textSet(Font001, 36, CENTER, CENTER);
  ftextb(nf(SelectClockHour, 2)+":"+nf(SelectClockMinute, 2), 320, 600, TextColor[1], TextColor[0]);

  //ごぜんごご（面倒なのでトグルswitchで）
  textSet(Font001, 36, CENTER, CENTER);
  if (dist(mouseX, mouseY, 80, 600) < 48) {
    ftextb(SelectAMPM[Select12Flg], 80, 600, TextColor[0], TextColor[1]);
    if (mouseKey == 1) {
      mouseKey = 2;
      Select12Flg = (Select12Flg == 0) ? 1 : 0;
    }
  } else ftextb(SelectAMPM[Select12Flg], 80, 600, TextColor[1], TextColor[0]);
}