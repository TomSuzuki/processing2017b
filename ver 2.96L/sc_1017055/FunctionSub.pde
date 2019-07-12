//新規作成ボタン（統合版）
void MakeNewButton(int y, int flg, int c) {
  textSet(Font001, 24, CENTER, CENTER);
  if (mouseX > 30 && mouseX < 440 && mouseY > y && mouseY < y+48 && mouseKey != 3) {
    frect(30, y, 420, 48, BarColorSub, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      switch(c) {
      case 0://メモ
        BeforeFlgMemo = flg;
        MasterFlg = 11;
        //メモ関連
        pMemoName = "data/memo/"+year()+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2)+".txt";  //めもたいとる
        //キーボードの初期値（SubCount作ったからそこでやればいいのに←自分で書いてるんだろうが）
        KeyBodeUnsettled = "";
        KeyBodeDraw = "";
        NowLine = KeyBodeDraw.length();
        break;
      case 1://イベント
        NewEventFlg = 0;
        NewEventFlg3 = 0;
        SelectYearYear = SelectYear;
        SelectDateMonth = SelectMonth;
        SelectDateDay = SelectDay;
        BefireFlgNewEvent = flg;
        MasterFlg = 121;
        break;
      case 2://科目
        BefireFlgNewSubject = flg;
        MasterFlg = 32;
        break;
      case 3://科目
        BeforeFlg = flg;
        MasterFlg = 100;
        break;
      }
    }
  } else frect(30, y, 420, 48, BarColorSub, FillAlpha);
  ftextb("＋ 新規作成    ", 240, y+24, TextColor[1], TextColor[0]);
}

//スケジュールのロード
void LoadSchedule(String filepass) {

  //空白の行を消す
  DelLine(filepass, "");//動くかわからん

  //読み込み
  String TempString;
  float TempFloat;
  MakeFileNoFile(filepass, "");
  String[] c = loadStrings(filepass);
  ScheduleDate = new String[c.length];    //YYYY/MM/DD
  ScheduleTime = new String[c.length];    //hh/mm
  ScheduleSubject = new String[c.length]; //科目名
  ScheduleMemo = new String[c.length];    //[\n]は[%n]に置き換えてある
  SchedulePercent = new float[c.length];  //0.0 - 1.0
  ScheduleStudyTime = new float[c.length];//学習時間
  for (int i = 0; i < c.length; i++) {
    String[] d = split(c[i], ",");
    if (d.length > 3) {//変数名のまま
      ScheduleDate[i] = d[0];
      ScheduleTime[i] = d[1];
      ScheduleSubject[i] = d[2];
      ScheduleMemo[i] = d[5];
      SchedulePercent[i] = float(d[3]);
      ScheduleStudyTime[i] = float(d[4]);
    }
  }

  //並べ替え（とってもとっても頭の悪いソートだよ（デバッグ面倒だから簡単に←そんなことするから処理重くなる←classをつかえwww））
  for (int i = 0; i < ScheduleDate.length; i++) {
    for (int j = 0; j < ScheduleDate.length; j++) {
      if (chDate(ScheduleDate[j], ScheduleDate[i]) || (ScheduleDate[i].equals(ScheduleDate[j]) && chTime(ScheduleTime[j], ScheduleTime[i]))) {//並べ替える
        TempString = ScheduleDate[i];
        ScheduleDate[i] = ScheduleDate[j];
        ScheduleDate[j] = TempString;
        TempString = ScheduleSubject[i];
        ScheduleSubject[i] = ScheduleSubject[j];
        ScheduleSubject[j] = TempString;
        TempString = ScheduleMemo[i];
        ScheduleMemo[i] = ScheduleMemo[j];
        ScheduleMemo[j] = TempString;
        TempString = ScheduleTime[i];
        ScheduleTime[i] = ScheduleTime[j];
        ScheduleTime[j] = TempString;
        TempFloat = SchedulePercent[i];
        SchedulePercent[i] = SchedulePercent[j];
        SchedulePercent[j] = TempFloat;
        TempFloat = ScheduleStudyTime[i];
        ScheduleStudyTime[i] = ScheduleStudyTime[j];
        ScheduleStudyTime[j] = TempFloat;
      }
    }
  }

  //再セーブ
  SaveSchedule(filepass);
}

//前日を返す関数
String yesterday(String p1) {
  String n = p1;
  int b1;
  int b2;
  int b3;
  String[] a = split(p1, "/");
  if (a.length > 2) {
    b1 = int(a[0]);
    b2 = int(a[1]);
    b3 = int(a[2]);
    if (b3 == 1) {//1日？
      if (b2 == 1) {//1月？
        b3 = 31;
        b2 = 12;
        b1 = b1 - 1;
      } else {//それ以外
        b2 = b2 - 1;
        b3 = getDays(b1, b2);
      }
    } else {
      b3 = b3 - 1;
    }
    n = b1 + "/" + b2 + "/" + b3;//組み立てる
  }
  return n;
}

//スケジュールセーブ（単純一括）
void SaveSchedule(String p1) {
  String[] a = new String[ScheduleDate.length];

  for (int i = 0; i < a.length; i++) a[i] = ScheduleDate[i]+","+ScheduleTime[i]+","+ScheduleSubject[i]+","+SchedulePercent[i]+","+ScheduleStudyTime[i]+","+ScheduleMemo[i];

  saveStrings(p1, a);

  DelLine(p1, "");
}

//時計の描画の実行
void Clock(int x, int y, int h, int m) {
  textSet(Font001, 14, LEFT, TOP);
  if (h < 12) ftextb("a.m.", x-70, y-70, TextColor[1], TextColor[0]);//ごぜんごご
  else ftextb("p.m.", x-70, y-70, TextColor[1], TextColor[0]);
  if (dist(mouseX, mouseY, x, y) < 64) { //はんい
    if (mouseKey == 1) {
      mouseKey = 2;
      BeforeFlg2 = MasterFlg;
      Img000 = ImgBefore.get();  
      SelectClockMinute = m;
      SelectClockHour = h;
      Select12Flg = h/12;
      MasterFlg = 22;
    }
  } else fellipse(x, y, 130, 130, MainColor, 255);
  m = 60 - m + 30;
  h = 12 - h + 6;
  fellipse(x, y, 128, 128, BarColorSub, FillAlpha);
  textSet(Font001, 12, CENTER, CENTER);//文字盤
  ftextb("12", x, y-52, TextColor[1], TextColor[0]);
  ftextb("3", x+52, y, TextColor[1], TextColor[0]);
  ftextb("6", x, y+52, TextColor[1], TextColor[0]);
  ftextb("9", x-52, y, TextColor[1], TextColor[0]);
  //もっと簡単にできんかなぁ
  strokeWeight(4);
  fline(x, y, x+52*sin(radians(m*360/60)), y+52*cos(radians(m*360/60)), TextColor[0], 255);
  strokeWeight(2);
  fline(x, y, x+52*sin(radians(m*360/60)), y+52*cos(radians(m*360/60)), MainColor, 255);
  strokeWeight(4);
  fline(x, y, x+36*sin(radians(h*360/12)), y+36*cos(radians(h*360/12)), TextColor[0], 255);
  strokeWeight(2);
  fline(x, y, x+36*sin(radians(h*360/12)), y+36*cos(radians(h*360/12)), SubColor, 255);
  noStroke();
  //中心の○
  fellipse(x, y, 6, 6, MainColor, 255);
  fellipse(x, y, 4, 4, BarColor, FillAlpha);
}

//カレンダー（日付の表示と編集行き）
void Date(int x, int y, int yyyy, int mm, int dd) {
  y = y + 35;
  if (mouseX > x && mouseX < x+180 && mouseY > y && mouseY < y+48) {
    frect(x, y, 180, 48, SubColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      BeforeFlg2 = MasterFlg;
      mouseKey = 2;
      Img000 = ImgBefore.get();  
      SelectYearYear = yyyy;
      SelectDateMonth = mm;
      SelectDateDay = dd;
      BeforeFlg2 = MasterFlg;
      MasterFlg = 21;//月日編集
    }
  }
  if (mouseX > x && mouseX < x+128 && mouseY > y-35 && mouseY < y-5) {
    frect(x, y-35, 128, 30, SubColor, FillAlphaSub);    
    if (mouseKey == 1) {
      mouseKey = 2;
      Img000 = ImgBefore.get();
      SelectYearYear = yyyy;
      BeforeFlg2 = MasterFlg;
      MasterFlg = 20;//年編集
    }
  }
  frect(x+5, y-35, 82, 30, BarColor, FillAlpha);
  frect(x, y, 48, 48, BarColor, FillAlpha);
  frect(x+96, y, 48, 48, BarColor, FillAlpha);
  textSet(Font001, 24, LEFT, TOP);
  ftextb("月", x+54, y+24, TextColor[1], TextColor[0]);
  ftextb("日", x+150, y+24, TextColor[1], TextColor[0]);
  ftextb("年", x+96, y-30, TextColor[1], TextColor[0]);
  textSet(Font001, 20, CENTER, CENTER);
  ftextb(str(yyyy), x+46, y-20, TextColor[1], TextColor[0]);
  textSet(Font001, 32, CENTER, CENTER);
  ftextb(str(mm), x+24, y+24, TextColor[1], TextColor[0]);
  ftextb(str(dd), x+120, y+24, TextColor[1], TextColor[0]);
  textSet(Font001, 12, CENTER, CENTER);
  ftextb("（"+WeekDay2[dayweek(yyyy, mm, dd)]+"）", x+148, y-14, TextColor[1], TextColor[0]);
}

//メモの描画と実行（メモのスクロールができないのは仕様。仕様..仕様.....）
void Memo(String p1, int x, int y) {

  //置き換え
  p1 = p1.replaceAll("%n", "\n");

  //描画
  frect(x-2, y-2, 244, 244, MainColor, 255);
  frect(x, y, 240, 240, BarColorSub, 255);
  textSet(Font001, 16, LEFT, TOP);
  ftextb2(p1, x+15, y+10, TextColor[1], TextColor[0], 210, 220);

  //編集ボタン
  frect(x, y+200, 240, 38, BarColorSub, 255);
  if (mouseX > x+2 && mouseX < x+238 && mouseY > y+200 && mouseY < y+238) {
    frect(x+2, y+200, 236, 38, MainColor, FillAlphaSub);
    if (mouseKey == 1) {
      BeforeFlgMemo = MasterFlg;
      MasterFlg = 11;
      mouseKey = 2;
      //キーボードの初期値
      KeyBodeUnsettled = "";
      KeyBodeDraw = p1.replaceAll("%n", "\n");
      NowLine = KeyBodeDraw.length();
    }
  }
  frect(x+2, y+200, 236, 38, MainColor, FillAlpha);
  textSet(Font001, 24, CENTER, CENTER);
  ftextb("編集する", x+120, y+220, TextColor[1], TextColor[0]);
}

//科目のバー
void BarSubject(String p1, int p2, float p3, String memo, String time) {
  //描画
  frect(1, p2+1, width-2, 70, #EEEEEE, FillAlpha);
  frect(1, p2+1, 18, 70, unhex(vlookup(p1, SubjectList, SubjectColor)), FillAlpha);
  textSet(Font001, 24, LEFT, TOP);
  ftextb(p1, 70, p2+15, TextColor[1], TextColor[0]);  
  //Percent
  if (p3 != -1) {
    fdrawPi(420, p2+36, 50, 0.0, 1.0, MainColor, FillAlphaSub);
    fdrawPi(420, p2+36, 48, 0.0, 1.0, BarColor, FillAlpha);
    fdrawPi(420, p2+36, 48, 0.0, p3, unhex(vlookup(p1, SubjectList, SubjectColor)), FillAlpha);
    textSet(Font001, 14, CENTER, CENTER);
    ftextb(int(p3*100)+"%", 420, p2+36, TextColor[1], TextColor[0]);
  }
  //メモ
  textSet(Font001, 16, LEFT, BOTTOM);
  if (memo.replaceAll("%n"," ").length() < 20) ftextb(memo.replaceAll("%n"," "), 78, p2+64, TextColor[1], TextColor[0]);
  else ftextb(memo.replaceAll("%n"," ").substring(0, 19)+"....", 78, p2+64, TextColor[1], TextColor[0]);
  //時間
  String[] a = split(time, ":");
  if (a.length > 1) {
    textSet(Font001, 12, CENTER, CENTER);
    ftextb(nf(int(a[0]), 2)+":"+nf(int(a[1]), 2), 44, p2+36, TextColor[1], TextColor[0]);
  }
}

//日付バー
void BarDate(String p1, float p2) {          
  frect(1, p2+1, 478, 30, BarColorSub, FillAlphaSub);
  textSet(Font001, 22, LEFT, CENTER);
  String[] a = split(p1, "/");
  ftextb(p1+"（"+WeekDay2[dayweek(int(a[0]), int(a[1]), int(a[2]))]+"）", 20, p2+16, TextColor[1], TextColor[0]);
}

//科目のロード
void LoadSubjectList(String filepass) {
  MakeFileNoFile(filepass, "");
  String[] FileLoad = loadStrings(filepass);
  SubjectList = new String[FileLoad.length];
  SubjectColor = new String[FileLoad.length];
  for (int i = 0; i < FileLoad.length; i = i + 1) {
    String[] Temp = split(FileLoad[i], ",");
    SubjectList[i] = Temp[1];
    SubjectColor[i] = Temp[0];
  }
}

//一つだけのボタン SingleButton
boolean SingleButton(String msg, int y) {  
  textSet(Font001, 28, CENTER, CENTER);
  if (mouseX > 1 && mouseX < 479 && mouseY > y+1 && mouseY < y+63) {
    frect(1, y+1, 479, 62, BarColorSub, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      return true;
    }
  }
  frect(1, y+1, 479, 62, BarColorSub, FillAlpha);
  ftextb(msg, 240, y+32, TextColor[1], TextColor[0]);
  return false;
}

//キャンセルと完了
int CompleteButton(boolean p1) {
  int n = 0;
  String[] a = {"キャンセル", "完了"};
  //描画
  textSet(Font001, 28, CENTER, CENTER);
  for (int i = 0; i < 2; i++) {
    if (mouseX > 1+i*240 && mouseX < i*240+240 && mouseY > 1 && mouseY < 63) {
      if (i == 0 || p1 == true) frect(1+i*240, 1, 238, 62, MainColor, FillAlphaSub);
      else frect(1+i*240, 1, 238, 62, BarColorSub, FillAlphaSub);
      if (mouseKey == 1) {
        mouseKey = 2;
        if (i == 0 || p1 == true) n = i + 1;
      }
    } else frect(1+i*240, 1, 238, 62, BarColorSub, FillAlpha);
    ftextb(a[i], i*240+120, 32, TextColor[1], TextColor[0]);
  }
  return n;
}

//設定のロード（テーマの初期化）
void LoadInitialize(String p1) {
  MakeFileNoFile(p1, default_FileInitialize);
  String[] FileLoad = loadStrings(p1);
  for (int i = 0; i < FileLoad.length; i = i + 1) {
    String[] Temp2 = split(FileLoad[i], ";");
    String[] Temp = split(Temp2[0], ",");
    if (Temp[0].equals("main-color")) MainColor = int(unhex(Temp[1]));
    else if (Temp[0].equals("sub-color")) SubColor = int(unhex(Temp[1]));
    else if (Temp[0].equals("bar-color")) BarColor = int(unhex(Temp[1]));
    else if (Temp[0].equals("bar-color-sub")) BarColorSub = int(unhex(Temp[1]));
    else if (Temp[0].equals("backgroung-img")) ImgBackground = loadImage(Temp[1]);
    else if (Temp[0].equals("backgroung-img-sub")) ImgBackgroundSub = loadImage(Temp[1]);
    else if (Temp[0].equals("alpha")) FillAlpha = int(Temp[1]);
    else if (Temp[0].equals("alpha-sub")) FillAlphaSub = int(Temp[1]);
    else if (Temp[0].equals("text-color1")) TextColor[0] = int(unhex(Temp[1]));
    else if (Temp[0].equals("text-color2")) TextColor[1] = int(unhex(Temp[1]));
    else if (Temp[0].equals("text-color3")) TextColor[2] = int(unhex(Temp[1]));
    else if (Temp[0].equals("font") && Font001 == null) Font001 = loadFont(Temp[1]);
    else if (Temp[0].equals("font-sub") && Font002 == null) Font002 = loadFont(Temp[1]);
  }
  for (int i = 0; i < 5; i ++) {
    ImgBackgroundSub2[i] = ImgBackgroundSub.get(0, 0, 480, 640);
    ImgBackgroundSub2[i].filter(BLUR, i*2);
  }

  //キャッシュクリア？
  g.removeCache(ImgBackground);
  g.removeCache(ImgBackgroundSub);
  for (int i = 0; i < 5; i ++) g.removeCache(ImgBackgroundSub2[i]);
}

//予測変換をする関数（どこかにいいライブラリあるだろうけど調べる時間が無かった）
String PredictiveTransformation(String Target) {
  //例外
  if (Target.equals("")) return "";
  //宣言とか
  String PredictiveTransformationReturn = "";
  String[] extensions = {""+Target.substring(0, 1)+".dic", "user.dic"};
  File cdirectory = new File(dataPath("dic"));
  File[] fileList = cdirectory.listFiles();
  int[] MaxMatch = new int[32];
  String[] MaxStr = new String[32];
  String[] MaxStr2 = new String[32];
  //読み込み
  for (int i = 0; i < fileList.length; i++) {
    for (String extension : extensions) {
      if (fileList[i].getPath().endsWith(extension)) {
        String[] DicTemp = loadStrings(fileList[i].getAbsolutePath());
        for (int j = 0; j < DicTemp.length; j++) {
          String[] DicTemp2 = split(DicTemp[j], ",");
          int ff = 0;//重複フラグ
          if (DicTemp2.length > 1) {//データある
            for (int c = 0; c < 32; c++) if (DicTemp2[1].equals(MaxStr[c])) ff = 1;//同じものがすでにRank内にあるか？
          } else ff = 1;//データない
          if (ff == 0) {//重複ない
            int n = 1;
            String a = "";
            String e = "";
            while (n <= DicTemp2[0].length() && n <= Target.length() && a.equals(e)==true) {
              a = Target.substring(0, n);
              e = DicTemp2[0].substring(0, n);
              n = n + 1;
            }
            n = n - 1;
            if (a.equals(e)==false) n = n - 1;
            if (n > MaxMatch[MaxMatch.length-1]) {
              int v = 0, flg = 0;
              while (v < MaxMatch.length && flg == 0) {
                if (n > MaxMatch[v]) {//記録する
                  int c = 0;
                  flg = 1;
                  for (c = MaxMatch.length-1; c > v; c--) {
                    MaxMatch[c] = MaxMatch[c-1];
                    MaxStr[c] = MaxStr[c-1];
                    MaxStr2[c] = MaxStr2[c-1];
                  }
                  MaxMatch[v] = n;
                  MaxStr[v] = DicTemp2[1];
                  MaxStr2[v] = DicTemp2[0];
                }
                v = v + 1;
              }
            }
          }
        }
      }
    }
  }

  for (int i = 0; i < MaxStr.length; i++) if (MaxStr[i] != null) if (MaxStr[i].equals("") == false) PredictiveTransformationReturn = PredictiveTransformationReturn + MaxStr2[i] + "," + MaxStr[i] + "," + MaxMatch[i] + ";";

  return PredictiveTransformationReturn;
}

//なんかそれっぽい結果返るからいいかなって思っている（スケジューラだし逆に計算して4桁の数字を出すのが面倒だなって感じる程度の強度でいいと思う（一部の数だけでわかるよこれ←知ってる））
//改良したけど意味ないよなぁ...（どうやったらいいんだろう...）
int[] Pkey = {75653, 78977, 96329, 113011};
String Returnkey = "";
boolean keyFG(String p1, String p2) {//p1...暗号化されたキー / p2...一致するか調べるキー
  long Gkey = 7;
  String Rkey = "";
  p2 = nf(int(p2), 4);
  int[] Ckey = {int(p2.substring(0, 1))*31+7, int(p2.substring(1, 2))*13+79, int(p2.substring(2, 3))*17+53, int(p2.substring(3, 4))*23+29};
  for (int i = 0; i < 4; i++) for (int j = 5; j > 1; j--) Gkey = (Gkey*Ckey[i] + ((Pkey[i]*j+int(p2.substring(i, i+1)))));
  if (Gkey < 0) Gkey = -Gkey;
  while (Gkey > 0) {
    Rkey = Rkey + (Gkey%10);
    Gkey = Gkey / 10;
  }

  Returnkey = Rkey;
  //println(Returnkey);
  if (Returnkey.equals(p1)) return true;
  return false;
}