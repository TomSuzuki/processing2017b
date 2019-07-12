//カレンダーサブ（カレンダー表示）
int CalendarSubScroll = 0, CalendarSubPosY = 0;
int[] CalendarSubNum = new int[31];
float[] CalendarSubAvg = new float[31];
int CalendarSubpMonth = -1;
int CalendarSubFlg = -1;
void MasterCalendarSub() {
  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //初期化
  if (SubCount == 0) {
    CalendarSubPosY = 0;
    CalendarSubScroll = 0;
    Img000 = ImgBackground.get(0, 0, 480, 472);
    CalendarSubpMonth = -1;
    CalendarSubFlg = -1;
  }

  //課題の達成度（日ごと）
  if (CalendarSubpMonth != SelectMonth) {    
    for (int i = 0; i < 31; i++) {
      CalendarSubNum[i] = 0;
      CalendarSubAvg[i] = 0.0;
    }
    for (int i = 0; i < ScheduleDate.length; i++) {
      String[] t = split(ScheduleDate[i], "/");
      if (int(t[0]) == SelectYear && int(t[1]) == SelectMonth) {
        CalendarSubNum[int(t[2])-1] = CalendarSubNum[int(t[2])-1] + 1;
        CalendarSubAvg[int(t[2])-1] = CalendarSubAvg[int(t[2])-1] + SchedulePercent[i];
      }
    }
    for (int i = 0; i < 31; i++) if (CalendarSubNum[i] != 0) CalendarSubAvg[i] = CalendarSubAvg[i] / CalendarSubNum[i];
  }

  //日付
  /*frect(2, 468, 476, 30, BarColor, FillAlpha);
   textSet(Font001, 18, LEFT, CENTER);
   ftextb(SelectYear+"年"+SelectMonth+"月"+SelectDay+"日（"+WeekDay2[dayweek(SelectYear, SelectMonth, SelectDay)]+"）", 18, 468+15, TextColor[1], TextColor[0]);*/

  //スクロール
  if (mouseKey == 1 && abs(pmouseY - mouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) CalendarSubScroll = CalendarSubScroll + (pmouseY - mouseY);
  if (CalendarSubPosY - 180 < CalendarSubScroll) CalendarSubScroll = CalendarSubPosY - 180;//未完成
  if (CalendarSubScroll < 0) CalendarSubScroll = 0;

  //項目  
  if (mouseKey == 3) CalendarSubFlg = -1;
  if (CalendarSubFlg != -1 && mouseKey == 0) MasterFlg = CalendarSubFlg;
  int PosY = 472-48 - CalendarSubScroll;
  String pDate = "";
  for (int i = 0; i < ScheduleDate.length; i++) {
    if (ScheduleDate[i] != null && ScheduleDate[i].equals(SelectYear+"/"+SelectMonth+"/"+SelectDay)) {
      if (pDate.equals(ScheduleDate[i]) == false) {
        PosY = PosY + 48;
        BarDate(ScheduleDate[i], PosY);
        PosY = PosY + 32;
      }
      if (mouseY > PosY+1 && mouseY < PosY+71 && mouseX > 1 && mouseX < 479 && mouseY > 178) {
        if (mouseKey == 1) {
          frect(1, PosY+1, 478, 70, MainColor, FillAlphaSub);
          //設定情報を入れる
          BeforeFlg = MasterFlg;
          CalendarSubFlg = 101;
          SettingHomeworkSubject = ScheduleSubject[i];
          String[] o = split(ScheduleTime[i], ":");
          SettingHomeworkHour = int(o[0]);
          SettingHomeworkMinute = int(o[1]);
          String[] t = split(ScheduleDate[i], "/");
          SettingHomeworkDay = int(t[2]);
          SettingHomeworkMonth = int(t[1]);
          SettingHomeworkYear = int(t[0]);
          SettingHomeworkMemo = ScheduleMemo[i];
          SettingHomeworkPar = SchedulePercent[i];
          SettingHomeworkStudyTime = ScheduleStudyTime[i];
          SettingHomeworkpData = (SettingHomeworkYear+"/"+SettingHomeworkMonth+"/"+SettingHomeworkDay)+","+(SettingHomeworkHour+":"+SettingHomeworkMinute)+","+SettingHomeworkSubject+","+SettingHomeworkPar+","+SettingHomeworkStudyTime+","+SettingHomeworkMemo;
        } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
      }
      BarSubject(ScheduleSubject[i], PosY, SchedulePercent[i], ScheduleMemo[i]);
      PosY = PosY + 72;
      pDate = ScheduleDate[i];
    }
  }
  CalendarSubPosY = PosY+CalendarSubScroll-(427-48);

  //上部文字盤
  image(Img000, 0, 0);
  frect(2, 2, 476, 70, SubColor, FillAlphaSub);
  textSet(Font001, 16, CENTER, CENTER);
  ftextb(SelectYear+"年", 240, 20, TextColor[1], TextColor[0]);
  textSet(Font001, 24, CENTER, CENTER);
  ftextb(SelectMonth+"月", 240, 50, TextColor[1], TextColor[0]);

  //上部切り替えボタン（年）
  textSet(Font001, 16, CENTER, CENTER);
  if (kyori(mouseX, mouseY, 190, 20) < 12) {
    ftextb("＜", 190, 20, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectYear = SelectYear - 1;
    }
  } else ftextb("＜", 190, 20, TextColor[2], TextColor[0]);
  if (kyori(mouseX, mouseY, 290, 20) < 12) {
    ftextb("＞", 290, 20, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectYear = SelectYear + 1;
      SelectDay = 1;
    }
  } else ftextb("＞", 290, 20, TextColor[2], TextColor[0]);
  if (SelectYear < 1900) SelectYear = 1900;

  //上部切り替えボタン（月）
  textSet(Font001, 24, CENTER, CENTER);
  if (kyori(mouseX, mouseY, 180, 50) < 20) {
    ftextb("＜", 180, 50, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectMonth = SelectMonth - 1;
      SelectDay = 1;
    }
  } else ftextb("＜", 180, 50, TextColor[2], TextColor[0]);
  if (kyori(mouseX, mouseY, 300, 50) < 12) {
    ftextb("＞", 300, 50, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectMonth = SelectMonth + 1;
      SelectDay = 1;
    }
  } else ftextb("＞", 300, 50, TextColor[2], TextColor[0]);
  if (SelectMonth < 1) SelectMonth = 12;
  if (SelectMonth > 12) SelectMonth = 1;

  //カレンダーの描画
  int mStart = dayweek(SelectYear, SelectMonth, 1);
  int mdays = getDays(SelectYear, SelectMonth);
  textSet(Font001, 16, CENTER, CENTER);
  for (int j = 0; j < 7; j++) {
    //frect(67*j+5, 76, 66, 32, BarColorSub, FillAlphaSub);
    frect(67*j+5, 76, 66, 32, MainColor, FillAlphaSub);
    ftextb(WeekDay[j], 67*j+38, 92, TextColor[1], TextColor[0]);
  }
  for (int i = 0; i < 6; i++) for (int j = 0; j < 7; j++) {
    if (mouseX > 67*j+5 && mouseX < 67*j+5+66 && mouseY > 48*i+112 && mouseY < 48*i+112+46) {
      frect(67*j+5, 48*i+112, 66, 46, BarColorSub, FillAlphaSub);
      if (mouseKey == 1) {
        mouseKey = 2;
        if (i*7+j-mStart >= 0 && i*7+j-mStart < mdays) SelectDay = i*7+j-mStart+1;
      }
    } else frect(67*j+5, 48*i+112, 66, 46, BarColorSub, FillAlpha);
  }
  textSet(Font001, 24, CENTER, CENTER);
  for (int i = 0; i < mdays; i++) if (CalendarSubNum[i] != 0) {
    //fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 42, 0.0, 1.0, BarColor, FillAlphaSub);
    //fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 42, 0.0, CalendarSubAvg[i], MainColor, FillAlpha);
    fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 42, 0.0, 1.0, TextColor[1], FillAlphaSub);
    fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 42, 0.0, CalendarSubAvg[i], TextColor[0], FillAlpha);
  }
  for (int i = 0; i < mdays; i++) {
    if (i+1 == SelectDay) frect(67*int((i+mStart)%7)+5, 48*int((i+mStart)/7)+112, 66, 46, MainColor, FillAlpha);
    ftextb(str(1+i), 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, TextColor[1], TextColor[0]);
  }

  //新規作成ボタン
  MakeNewTask(410, 2);

  //セレクトタブボタン
  if (mouseX > 10 && mouseX < 58 && mouseY > 10 && mouseY < 58) {
    tint(255);
    if (mouseKey == 1) {
      ResetSelect();
      mouseKey = 2;
    }
  } else tint(128);
  image(Img002, 10, 10);
}