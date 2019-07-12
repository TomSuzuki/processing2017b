//カレンダーメインの初期化
String[] CalendarMainTabMsg = {"未完了", "完了済", "すべて", "記録"};
int CalendarMainNowTab = 0;
int CalendarMainScroll = 0;
int CalendarMainPosY = 0;
int CalendarMainFlg = -1;
int pSelectMonth = -1, pSelectYear = -1;
float RecordTotalTime = 0.0;
float[] RecordTotalTimeSubject;
int[] RecordTotalTimeSubjectI;
//カレンダーメイン（リスト表示）
void MasterCalendarMain() {
  //処理
  if (SubCount == 0) {
    SelectDay = day();
    SelectMonth = month();
    SelectYear = year();
    CalendarMainScroll = 0;
    CalendarMainPosY = 0;
    CalendarMainFlg = -1;    
    pSelectMonth = -1;
    pSelectYear = -1;
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  if (ImgBackground != null) image(ImgBackground, 0, 0);

  //スクロール
  if (mouseKey == 1 && abs(pmouseY - mouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) CalendarMainScroll = CalendarMainScroll + (pmouseY - mouseY);
  if (CalendarMainPosY - 320 < CalendarMainScroll) CalendarMainScroll = CalendarMainPosY - 320;//ここ修正する
  if (CalendarMainScroll < 0) CalendarMainScroll = 0;

  //毎ループの初期化
  int PosY = 130 - CalendarMainScroll;//178 - 48;
  String pDate = "";

  //リストの描画
  if (mouseKey == 3) CalendarMainFlg = -1;
  if (CalendarMainFlg != -1 && mouseKey == 0) MasterFlg = CalendarMainFlg;
  switch(CalendarMainNowTab) {
  case 0://未完了のみ
    for (int i = 0; i < ScheduleDate.length; i++) {
      if (ScheduleDate[i] != null && (ScheduleDate[i].equals(year()+"/"+month()+"/"+day()) || chDate(ScheduleDate[i], year()+"/"+month()+"/"+day())) && SchedulePercent[i] < 1) {
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
            CalendarMainFlg = 101;
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
            //0%のときだけおかしい？
          } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
        }
        BarSubject(ScheduleSubject[i], PosY, SchedulePercent[i], ScheduleMemo[i]);
        PosY = PosY + 72;
        pDate = ScheduleDate[i];
      }
    }
    break;
  case 1://完了済みのみ
    for (int i = 0; i < ScheduleDate.length; i++) {
      if (ScheduleDate[i] != null && (ScheduleDate[i].equals(year()+"/"+month()+"/"+day()) || chDate(ScheduleDate[i], year()+"/"+month()+"/"+day())) && SchedulePercent[i] == 1) {
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
            CalendarMainFlg = 101;
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
            //0%のときだけおかしい？
          } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
        }
        BarSubject(ScheduleSubject[i], PosY, SchedulePercent[i], ScheduleMemo[i]);
        PosY = PosY + 72;
        pDate = ScheduleDate[i];
      }
    }
    break;
  case 2://すべて
    for (int i = 0; i < ScheduleDate.length; i++) {
      if (ScheduleDate[i] != null && (ScheduleDate[i].equals(year()+"/"+month()+"/"+day()) || chDate(ScheduleDate[i], year()+"/"+month()+"/"+day()))) {
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
            CalendarMainFlg = 101;
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
            //0%のときだけおかしい？
          } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
        }
        BarSubject(ScheduleSubject[i], PosY, SchedulePercent[i], ScheduleMemo[i]);
        PosY = PosY + 72;
        pDate = ScheduleDate[i];
      }
    }
    break;
  case 3://記録
    //UIどーしよ
    //ここ計画外の機能なんだよなぁ
    //でもこれないとなぁ
    //年月切り替え（年）
    //（同日）UI設計するかぁ～
    if (pSelectMonth != SelectMonth || pSelectYear != SelectYear) {//データの作成
      RecordTotalTimeSubject = new float[SubjectList.length];
      RecordTotalTimeSubjectI = new int[SubjectList.length];
      for (int i = 0; i < RecordTotalTimeSubjectI.length; i++) RecordTotalTimeSubjectI[i] = i;
      pSelectMonth = SelectMonth;
      pSelectYear = SelectYear;
      RecordTotalTime = 0;
      for (int i = 0; i < ScheduleDate.length; i++) {
        String[] a = split(ScheduleDate[i], "/");
        if (int(a[0]) == SelectYear && int(a[1]) == SelectMonth && SchedulePercent[i] == 1) {
          RecordTotalTime = RecordTotalTime + ScheduleStudyTime[i];
          int c = alookup(SubjectList, ScheduleSubject[i]);
          if (c != -1) RecordTotalTimeSubject[c] = RecordTotalTimeSubject[c] + ScheduleStudyTime[i];
        }
      }
      //ソート
      int int_t;
      float float_t;
      for (int i = 0; i < SubjectList.length; i++) for (int j = 0; j < SubjectList.length; j++) {
        if (RecordTotalTimeSubject[i] > RecordTotalTimeSubject[j]) {
          int_t = RecordTotalTimeSubjectI[i];
          float_t = RecordTotalTimeSubject[i];
          RecordTotalTimeSubjectI[i] = RecordTotalTimeSubjectI[j];
          RecordTotalTimeSubject[i] = RecordTotalTimeSubject[j];
          RecordTotalTimeSubjectI[j] = int_t;
          RecordTotalTimeSubject[j] = float_t;
        }
      }
    }
    textSet(Font001, 18, CENTER, TOP);
    ftextb(SelectYear+"年", 240, 120, TextColor[1], TextColor[0]);
    if (kyori(190, 120, mouseX, mouseY) < 12) {
      ftextb("＜", 190, 120, MainColor, TextColor[0]);
      if (mouseKey == 1) {
        mouseKey = 2;
        SelectYear = SelectYear - 1;
      }
    } else ftextb("＜", 190, 120, TextColor[1], TextColor[0]);
    if (kyori(290, 120, mouseX, mouseY) < 12) {
      ftextb("＞", 290, 120, MainColor, TextColor[0]);      
      if (mouseKey == 1) {
        mouseKey = 2;
        SelectYear = SelectYear + 1;
      }
    } else ftextb("＞", 290, 120, TextColor[1], TextColor[0]);

    //年月切り替え（月）
    textSet(Font001, 24, CENTER, TOP);
    ftextb(SelectMonth+"月", 240, 148, TextColor[1], TextColor[0]);
    if (kyori(180, 148, mouseX, mouseY) < 12) {
      ftextb("＜", 180, 148, MainColor, TextColor[0]);
      if (mouseKey == 1) {
        mouseKey = 2;
        SelectMonth = SelectMonth - 1;
        if (SelectMonth < 1) {
          SelectYear = SelectYear - 1;
          SelectMonth = 12;
        }
      }
    } else ftextb("＜", 180, 148, TextColor[1], TextColor[0]);
    if (kyori(300, 148, mouseX, mouseY) < 12) {
      ftextb("＞", 300, 148, MainColor, TextColor[0]);
      if (mouseKey == 1) {
        mouseKey = 2;
        SelectMonth = SelectMonth + 1;
        if (SelectMonth > 12) {
          SelectYear = SelectYear + 1;
          SelectMonth = 1;
        }
      }
    } else ftextb("＞", 300, 148, TextColor[1], TextColor[0]);

    if (RecordTotalTime > 0) {
      //円グラフ
      float t = 0.0;
      fdrawPi(240, 440, 300, 0.0, 1.0, MainColor, FillAlpha);
      for (int i = 0; i < RecordTotalTimeSubject.length; i++) if (RecordTotalTimeSubject[i] > 0) {
        fdrawPi(240, 440, 298, t/RecordTotalTime, (t+RecordTotalTimeSubject[i])/RecordTotalTime, unhex(SubjectColor[RecordTotalTimeSubjectI[i]]), 255);
        t = t + RecordTotalTimeSubject[i];
      }

      t = 0.0;
      textSet(Font001, 12, CENTER, CENTER);
      for (int i = 0; i < RecordTotalTimeSubject.length; i++) if (RecordTotalTimeSubject[i] > 0) {           
        ftextb(SubjectList[RecordTotalTimeSubjectI[i]], 240+sin(radians(180-(t+RecordTotalTimeSubject[i]/2)*360/RecordTotalTime))*150, 440+cos(radians(180-(t+RecordTotalTimeSubject[i]/2)*360/RecordTotalTime))*150, TextColor[1], TextColor[0]);
        ftextb(int((RecordTotalTimeSubject[i])*100/RecordTotalTime)+"%", 240+sin(radians(180-(t+RecordTotalTimeSubject[i]/2)*360/RecordTotalTime))*150, 440+cos(radians(180-(t+RecordTotalTimeSubject[i]/2)*360/RecordTotalTime))*150+20, TextColor[1], TextColor[0]);        
        t = t + RecordTotalTimeSubject[i];
      }

      //文字
      textSet(Font001, 48, CENTER, TOP);
      ftextb("Total  "+int(RecordTotalTime)+"."+(int((RecordTotalTime*2)%2)*5)+"h", 240, 200, TextColor[1], TextColor[0]);
      break;
    } else {    
      textSet(Font001, 24, CENTER, CENTER);
      ftextb("記録がありません", 240, 360, TextColor[1], TextColor[0]);
    }
  }

  CalendarMainPosY = PosY+CalendarMainScroll-130;
  if (PosY == 130 && CalendarMainNowTab != 3) {
    textSet(Font001, 24, CENTER, CENTER);
    ftextb("課題はありません", 240, 360, TextColor[1], TextColor[0]);
  }

  //上部文字盤
  if (CalendarMainNowTab != 3) image(ImgBackground.get(0, 0, 480, 176), 0, 0);
  frect(2, 2, 476, 70, SubColor, FillAlphaSub);
  textSet(Font001, 24, LEFT, TOP);
  ftextb(""+year()+"年"+nf(month(), 2)+"月"+nf(day(), 2)+"日（"+WeekDay2[dayweek(year(), month(), day())]+"）"+nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2), 72, 20, TextColor[1], TextColor[0]);

  //セレクトタブボタン（関数化しよう？）
  if (mouseX > 10 && mouseX < 58 && mouseY > 10 && mouseY < 58) {
    tint(255);
    if (mouseKey == 1) ResetSelect(); 
    mouseKey = (mouseKey == 1) ? 2 : mouseKey;  //使ってみたかっただけ
    /*if (mouseKey == 1) {
     ResetSelect();
     mouseKey = 2;
     }*/
  } else tint(128);
  image(Img002, 10, 10);

  //タブ
  for (int i = 0; i < 4; i++) CalendarMain_Tab(i, CalendarMainTabMsg[i]);

  //新規作成ボタン
  if (CalendarMainNowTab != 3) MakeNewTask(116, 1);
}

//タブの描画と処理（カレンダーリスト表示用）
void CalendarMain_Tab(int p1, String p2) {
  if (mouseX > 1+120*p1 && mouseX < 1+120*p1+118 && mouseY > 74 && mouseY < 114) {
    frect(1+120*p1, 74, 118, 30, BarColorSub, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      CalendarMainNowTab = p1;
    }
  } else frect(1+120*p1, 74, 118, 30, BarColorSub, FillAlpha);
  if (p1 == CalendarMainNowTab) frect(1+120*p1, 74, 118, 30, MainColor, FillAlphaSub);
  textSet(Font001, 18, CENTER, CENTER);
  if (p1 == CalendarMainNowTab) ftextb(p2, 120*p1+60, 89, TextColor[1], TextColor[0]);
  else ftextb(p2, 120*p1+60, 89, TextColor[2], TextColor[0]);
}