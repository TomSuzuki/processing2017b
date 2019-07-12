String[] EventName;
String[] EventMemo;
String[] EventDate;
String[] EventTime;
int[] EventThem;
String EventpData = "";
int EventScroll = 0, EventPosY = 0;
int EventSubFlg = -1;

//イベントリスト
void MasterEvent() {
  //初期化
  if (SubCount == 0) {
    Img000 = ImgBackground.get(0, 0, 480, 143);
    SelectYearYear = year();
    SelectDateMonth = month();
    SelectDateDay = day();
    EventScroll = 0;
    NewEventFlg = 0;
    EventSubFlg = -1;
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //スクロール
  if (mouseKey == 1 && abs(pmouseY - mouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) EventScroll = EventScroll + (pmouseY - mouseY);
  if (EventPosY - 320 < EventScroll) EventScroll = EventPosY - 320;//ここ修正する
  if (EventScroll < 0) EventScroll = 0;

  //バーとか
  if (mouseKey == 3) EventSubFlg = -1;
  if (EventSubFlg != -1 && mouseKey == 0) MasterFlg = EventSubFlg;
  int PosY = 98 - EventScroll;
  String pDate = "";
  for (int i = 0; i < EventDate.length; i++) {
    if (EventDate[i] != null && (EventDate[i].equals(year()+"/"+month()+"/"+day()) || chDate(EventDate[i], year()+"/"+month()+"/"+day()))) {
      if (pDate.equals(EventDate[i]) == false) {
        PosY = PosY + 48;
        BarDate(EventDate[i], PosY);
        PosY = PosY + 32;
      }
      if (mouseY > PosY+1 && mouseY < PosY+71 && mouseX > 1 && mouseX < 479 && mouseY > 178) {
        if (mouseKey == 1) {
          frect(1, PosY+1, 478, 70, MainColor, FillAlphaSub);
          BefireFlgNewEvent = MasterFlg;
          EventSubFlg = 121;
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
          //0%のときだけおかしい？
        } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
      }
      //BarSubject(ScheduleSubject[i], PosY, SchedulePercent[i], ScheduleMemo[i], ScheduleTime[i]);
      BarEvent(PosY, EventName[i],  EventTime[i], EventThem[i], EventMemo[i]);
      PosY = PosY + 72;
      pDate = EventDate[i];
    }
  }

  EventPosY = PosY+EventScroll-98;

  //上部文字盤
  image(Img000, 0, 0);
  frect(2, 2, 476, 70, SubColor, FillAlphaSub);
  textSet(Font001, 24, LEFT, TOP);
  ftextb(""+year()+"年"+nf(month(), 2)+"月"+nf(day(), 2)+"日（"+WeekDay2[dayweek(year(), month(), day())]+"）"+nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2), 72, 20, TextColor[1], TextColor[0]);

  //セレクトタブボタン（関数化しよう？）
  if (mouseX > 10 && mouseX < 58 && mouseY > 10 && mouseY < 58) {
    tint(255);
    if (mouseKey == 1) ResetSelect(); 
    mouseKey = (mouseKey == 1) ? 2 : mouseKey;  //使ってみたかっただけ
  } else tint(128);
  image(Img002, 10, 10);

  //新規作成ボタン
  MakeNewButton(84, 120, 1);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//新しいイベント
String NewEventName = "";
String NewEventMemo = "";
int NewEventColor = 0;
int NewEventYear = 1990;
int NewEventMonth = 1;
int NewEventDay = 1;
int NewEventHour = 0;
int NewEventMinute = 0;
int NewEventFlg = -1;
int NewEventFlg2 = 0;
int NewEventFlg3 = 0;
void NweEvent() {
  //初期化
  if (SubCount == 0) {
    //キーボードから戻ってきた
    if (KeyBodeUpDate.equals("") == false) {
      if (NewEventFlg2 == 1) {
        NewEventName = KeyBodeUpDate.substring(1, KeyBodeUpDate.length()).replaceAll("\n", " ");
        KeyBodeUpDate = "";
      } else {
        NewEventMemo = KeyBodeUpDate.substring(1, KeyBodeUpDate.length()).replaceAll( "\n", "%n");
      }
      NewEventFlg2 = 0;
      KeyBodeUpDate = "";
    } else {
      if (NewEventFlg == 0 && NewEventFlg3 == 0) {
        NewEventName = "";
        NewEventMemo = "";
        SelectClockHour = hour();
        SelectClockMinute = minute();
        Select12Flg = 0;
      }
    }
    NewEventYear = SelectYearYear;
    NewEventMonth = SelectDateMonth;
    NewEventDay = SelectDateDay;
    NewEventHour = SelectClockHour + 12*Select12Flg;
    NewEventMinute = SelectClockMinute;
    NewEventFlg3 = 1;
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //描画
  if (blimt(mouseX, 1, 479) && blimt(mouseY, 66, 66+70)) {
    frect(1, 67, width-2, 70, MainColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      NewEventFlg2 = 1;

      BeforeFlgMemo = MasterFlg;
      MasterFlg = 11;

      KeyBodeUnsettled = "";
      KeyBodeDraw = NewEventName;
      NowLine = NewEventName.length();
    }
  }
  BarEvent(66, NewEventName, "", NewEventColor, "");

  //メモ機能
  Memo(NewEventMemo, 220, 180);

  //日付
  Date(12, 180, NewEventYear, NewEventMonth, NewEventDay);

  //時計
  Clock(96, 356, NewEventHour, NewEventMinute);

  //カラー選択
  for (int i = 0; i < 6; i++) {
    if (blimt(mouseX, i*64+48, i*64+48+48) && blimt(mouseY, 500, 548)) {
      frect(i*64+46, 498, 52, 52, TextColor[1], 255);
      frect(i*64+47, 499, 50, 50, TextColor[0], 255);
      if (mouseKey == 1) NewEventColor = i;
    }
    frect(i*64+48, 500, 48, 48, EventColor[i], 255);
  }

  //キャンセル||完了
  switch(CompleteButton(NewEventName.equals("")==false)) {
  case 1://キャンセル
    MasterFlg = BefireFlgNewEvent;
    break;
  case 2://完了
    MasterFlg = BefireFlgNewEvent;
    if (NewEventFlg == 1) DelLine2(FileDataEvent, EventpData);//削除するデータあり（修正）
    //追加
    AddLine(FileDataEvent, NewEventName+","+(NewEventYear+"/"+NewEventMonth+"/"+NewEventDay)+","+(NewEventHour+":"+NewEventMinute)+","+NewEventColor+","+NewEventMemo.replaceAll("\n", "%n"));
    //更新
    LoadEvent();
    break;
  }

  //削除
  if (NewEventFlg == 1) if (SingleButton("削除", 576)) {
    //消す＆次へ
    DelLine2(FileDataEvent, EventpData);
    LoadEvent();
    MasterFlg = BefireFlgNewEvent;
  }

  //ツイートボタン
  if (SubCount == 0) tFlg = true;
  TweetButton(350, 450, "#tom_scheduler "+(NewEventYear+"/"+nf(NewEventMonth, 2)+"/"+nf(NewEventDay, 2))+" "+(nf(NewEventHour, 2)+":"+nf(NewEventMinute, 2)) +"に"+NewEventName+"があります。（"+NewEventMemo+"）", tFlg);
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//イベントバー
void BarEvent(int y, String title, String time, int tcolor, String memo) {
  //色
  frect(1, y+1, width-2, 70, #111111, FillAlpha);
  frect(1, y+1, 18, 70, EventColor[tcolor], FillAlpha);
  //イベントタイトル
  textSet(Font001, 24, LEFT, TOP);
  ftextb(title, 70, y+15, TextColor[1], TextColor[0]);  
  //メモ
  textSet(Font001, 16, LEFT, BOTTOM);
  if (memo.replaceAll("\n"," ").length() < 20) ftextb(memo.replaceAll("\n"," "), 78, y+64, TextColor[1], TextColor[0]);
  else ftextb(memo.replaceAll("\n"," ").substring(0, 19)+"....", 78, y+64, TextColor[1], TextColor[0]);
  //時間
  String[] a = split(time, ":");
  if (a.length > 1) {
    textSet(Font001, 12, CENTER, CENTER);
    ftextb(nf(int(a[0]), 2)+":"+nf(int(a[1]), 2), 44, y+36, TextColor[1], TextColor[0]);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//イベントのロード 
void LoadEvent() {
  String Pass = FileDataEvent;

  //ロード
  MakeFileNoFile(Pass, "");
  String[] t = loadStrings(Pass);
  EventName = new String[t.length];
  EventMemo = new String[t.length];
  EventDate = new String[t.length];
  EventTime = new String[t.length];
  EventThem = new int[t.length];
  for (int i = 0; i < t.length; i++) {
    String u[] = split(t[i], ",");
    if (u.length > 2) {
      EventName[i] = u[0];
      EventDate[i] = u[1];
      EventTime[i] = u[2];
      EventMemo[i] = u[4].replaceAll("%n", "\n");
      EventThem[i] = int(u[3]);
    }
  }

  //ソート
  String TempString = "";
  int TempInt = 0;
  for (int i = 0; i < EventDate.length; i++) {
    for (int j = 0; j < EventDate.length; j++) {
      if (chDate(EventDate[j], EventDate[i]) || (EventDate[j].equals(EventDate[i]) && chTime(EventTime[j], EventTime[i]))) {//並べ替える
        TempString = EventName[i];
        EventName[i] = EventName[j];
        EventName[j] = TempString;
        TempString = EventDate[i];
        EventDate[i] = EventDate[j];
        EventDate[j] = TempString;
        TempString = EventTime[i];
        EventTime[i] = EventTime[j];
        EventTime[j] = TempString;
        TempString = EventMemo[i];
        EventMemo[i] = EventMemo[j];
        EventMemo[j] = TempString;
        TempInt = EventThem[i];
        EventThem[i] = EventThem[j];
        EventThem[j] = TempInt;
      }
    }
  }

  //セーブ
  String a[] = {""};
  saveStrings(Pass, a);
  for (int i = 0; i < EventName.length; i++) AddLine(Pass, EventName[i]+","+EventDate[i]+","+EventTime[i]+","+EventThem[i]+","+EventMemo[i].replaceAll("\n", "%n"));
  DelLine(Pass, "");

  //ロード
  MakeFileNoFile(Pass, "");
  String[] t2 = loadStrings(Pass);
  EventName = new String[t2.length];
  EventMemo = new String[t2.length];
  EventDate = new String[t2.length];
  EventTime = new String[t2.length];
  EventThem = new int[t2.length];
  for (int i = 0; i < t2.length; i++) {
    String u[] = split(t2[i], ",");
    if (u.length > 2) {
      EventName[i] = u[0];
      EventDate[i] = u[1];
      EventTime[i] = u[2];
      EventMemo[i] = u[4].replaceAll("%n", "\n");
      EventThem[i] = int(u[3]);
    }
  }
}