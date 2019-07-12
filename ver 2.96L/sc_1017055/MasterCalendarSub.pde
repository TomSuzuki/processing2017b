//カレンダーサブ（カレンダー表示）
int CalendarSubScroll = 0, CalendarSubPosY = 0;
int[] CalendarSubNum = new int[31];
float[] CalendarSubAvg = new float[31];
int CalendarSubpMonth = -1;
int CalendarSubFlg = -1;
int CalendarSubMode = 0;
int[] CalendarSubEventNum = new int[31];
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

    //イベント数
    for (int i = 0; i < 31; i++) CalendarSubEventNum[i] = 0;
    for (int i = 0; i < EventDate.length; i++) {
      String[] t = split(EventDate[i], "/");
      if (int(t[0]) == SelectYear && int(t[1]) == SelectMonth) CalendarSubEventNum[int(t[2])-1] = CalendarSubEventNum[int(t[2])-1] + 1;
    }
  }

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
  if (CalendarSubMode == 0) {//課題
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
        BarSubject(ScheduleSubject[i], PosY, SchedulePercent[i], ScheduleMemo[i], ScheduleTime[i]);
        PosY = PosY + 72;
        pDate = ScheduleDate[i];
      }
    }
  } else {//イベント
    for (int i = 0; i < EventDate.length; i++) {
      if (EventDate[i] != null && (EventDate[i].equals(SelectYear+"/"+SelectMonth+"/"+SelectDay))) {        
        if (pDate.equals(EventDate[i]) == false) {
          PosY = PosY + 48;
          BarDate(EventDate[i], PosY);
          PosY = PosY + 32;
        }
        if (mouseY > PosY+1 && mouseY < PosY+71 && mouseX > 1 && mouseX < 479 && mouseY > 178) {
          if (mouseKey == 1) {
            frect(1, PosY+1, 478, 70, MainColor, FillAlphaSub);
            BefireFlgNewEvent = MasterFlg;
            CalendarSubFlg = 121;
            //設定情報を入れる
            NewEventFlg = 1;
            NewEventName = EventName[i];
            String[] o = split(EventTime[i], ":");
            SelectClockHour = int(o[0]);
            SelectClockMinute = int(o[1]);
            String[] t = split(EventDate[i], "/");
            SelectDateDay = int(t[2]);
            SelectDateMonth = int(t[1]);
            SelectYearYear = int(t[0]);
            NewEventMemo = EventMemo[i];
            NewEventColor = EventThem[i];
            EventpData = NewEventName+","+(SelectYearYear+"/"+SelectDateMonth+"/"+SelectDateDay)+","+(SelectClockHour+":"+SelectClockMinute)+","+NewEventColor+","+NewEventMemo.replaceAll("\n", "%n");
            Select12Flg = SelectClockHour / 12;
            SelectClockHour = SelectClockHour % 12;
          } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
        }
        BarEvent(PosY, EventName[i], EventTime[i], EventThem[i], EventMemo[i]);
        PosY = PosY + 72;
        pDate = EventDate[i];
      }
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
  if (dist(mouseX, mouseY, 190, 20) < 12) {
    ftextb("＜", 190, 20, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectYear = SelectYear - 1;
    }
  } else ftextb("＜", 190, 20, TextColor[2], TextColor[0]);
  if (dist(mouseX, mouseY, 290, 20) < 12) {
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
  if (dist(mouseX, mouseY, 180, 50) < 20) {
    ftextb("＜", 180, 50, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectMonth = SelectMonth - 1;
      SelectDay = 1;
    }
  } else ftextb("＜", 180, 50, TextColor[2], TextColor[0]);
  if (dist(mouseX, mouseY, 300, 50) < 12) {
    ftextb("＞", 300, 50, MainColor, TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      SelectMonth = SelectMonth + 1;
      SelectDay = 1;
    }
  } else ftextb("＞", 300, 50, TextColor[2], TextColor[0]);
  if (SelectMonth < 1) {
    SelectMonth = 12;
    SelectYear = SelectYear - 1;
  }
  if (SelectMonth > 12) {
    SelectMonth = 1;
    SelectYear = SelectYear + 1;
  }

  //カレンダーの描画
  int mStart = dayweek(SelectYear, SelectMonth, 1);
  int mdays = getDays(SelectYear, SelectMonth);
  textSet(Font001, 16, CENTER, CENTER);
  for (int j = 0; j < 7; j++) {
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
  for (int i = 0; i < mdays; i++) if (i+1 == day() && SelectYear == year() && SelectMonth == month()) frect(67*int((i+mStart)%7)+5, 48*int((i+mStart)/7)+112, 66, 46, MainColor, 255);
  textSet(Font001, 12, LEFT, TOP);
  for (int i = 0; i < mdays; i++) if (CalendarSubEventNum[i] != 0) {
    ftextb(str(CalendarSubEventNum[i]), 67*((i+mStart)%7)+8, 48*((i+mStart)/7)+112+4, TextColor[2], TextColor[0]);
  }
  textSet(Font001, 24, CENTER, CENTER);
  for (int i = 0; i < mdays; i++) if (CalendarSubNum[i] != 0) {
    fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 44, 0.0, 1.0, TextColor[0], FillAlphaSub);
    fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 42, 0.0, 1.0, TextColor[1], FillAlphaSub);
    fdrawPi( 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, 42, 0.0, CalendarSubAvg[i], TextColor[0], FillAlpha);
  }
  for (int i = 0; i < mdays; i++) {
    if (i+1 == SelectDay) frect(67*int((i+mStart)%7)+5, 48*int((i+mStart)/7)+112, 66, 46, MainColor, FillAlpha);
    ftextb(str(1+i), 67*((i+mStart)%7)+38, 48*((i+mStart)/7)+112+24, TextColor[1], TextColor[0]);
  }

  //課題||イベント//CalendarSubMode
  textSet(Font001, 14, CENTER, CENTER);
  frect(380-1, 18+4-12+CalendarSubMode*28-1, 82, 26, TextColor[1], FillAlphaSub);
  frect(380, 18+4-12+CalendarSubMode*28, 80, 24, TextColor[1], FillAlphaSub);
  if (blimt(mouseX, 380, 380+80) && blimt(mouseY, 18+4-12+((CalendarSubMode == 0) ? 1 : 0)*28, 18+4-12+((CalendarSubMode == 0) ? 1 : 0)*28+24) && mouseKey == 1) {
    mouseKey = 2;
    CalendarSubMode = (CalendarSubMode == 0) ? 1 : 0;
  }
  frect(380, 18+4-12, 80, 24, TextColor[0], FillAlpha);
  frect(380, 18+36-4-12, 80, 24, TextColor[0], FillAlpha);
  ftextb("課題", 420, 18+4, TextColor[1], TextColor[0]);
  ftextb("イベント", 420, 18+36-4, TextColor[1], TextColor[0]);

  //新規作成ボタン
  if (CalendarSubMode == 0) MakeNewButton(410, 2, 3);
  else MakeNewButton(410, 2, 1);

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