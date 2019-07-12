// ====================================================================================================================================================================================================================================================
//起動画面
int SartPosY = 0, StratTime = 0;
void MasterStart() {
  //処理
  if (mouseKey == 0) SartPosY = SartPosY - int(easing(SartPosY, 640, -2, 12, 2));
  else SartPosY = SartPosY + (mouseY - pmouseY);
  if (SartPosY > 0) SartPosY = 0;
  if (SartPosY < -520) MasterFlg = 0;
  StratTime = 0;

  if (SubCount == 0) {
    NowHomeworkList = "";
    if (MasterFlg == -2) {//ロード完了してから
      int num = 0;
      for (int i = 0; i < ScheduleDate.length; i++) if ((yesterday(ScheduleDate[i]).equals(year()+"/"+month()+"/"+day()) || ScheduleDate[i].equals(year()+"/"+month()+"/"+day())) && SchedulePercent[i] != 1) num = num + 1;
      if (num == 0) NowHomeworkList = "明日までの課題はありません。";
      else NowHomeworkList = "明日までの未完了課題が"+num+"件あります。";
    }
  }

  //スライド
  translate(0, SartPosY);

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackgroundSub, 0, 0);

  //時計
  textSet(Font002, 64, LEFT, TOP);
  ftextb(nf(hour(), 2)+":"+nf(minute(), 2), 20, 480, TextColor[1], TextColor[0]);
  textSet(Font002, 32, LEFT, TOP);
  ftextb(month()+"月"+day()+"日  "+WeekDay2[dayweek(year(), month(), day())]+"曜日", 20, 550, TextColor[1], TextColor[0]);

  //課題
  textSet(Font002, 16, RIGHT, BOTTOM);
  ftextb(NowHomeworkList, 460, 620, TextColor[1], TextColor[0]);

  //スライド
  translate(0, -SartPosY);

  //処理
  if (MasterFlg == 1) SartPosY = 0;
}


// ====================================================================================================================================================================================================================================================
//色の選択
int nextSettingColor = -1;
int ScrollSettingColor = 0;
void SettingColor() {
  //初期化
  if (SubCount == 0) {
    nextSettingColor = -1;
    Img000 = ImgBackground.get(0, 0, 480, 72);
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //スクロール（未完成というか何もやってない）
  if (mouseKey != 0 && 1 < abs(pmouseY - mouseY)) mouseKey = 3;
  if (mouseKey == 3) ScrollSettingColor = ScrollSettingColor + (mouseY - pmouseY);
  if (ScrollSettingColor < 320-pPosY) ScrollSettingColor = 320-pPosY;
  if (ScrollSettingColor > 0) ScrollSettingColor = 0;

  //初期
  int PosY = 72+ScrollSettingColor;

  //テーマの表示
  if (mouseKey == 3) nextSettingColor = -1;
  if (mouseKey == 0 && nextSettingColor != -1) {          //行の置き換え
    DelLine("data/base.ini", "main-color");
    DelLine("data/base.ini", "sub-color");
    DelLine("data/base.ini", "bar-color");
    DelLine("data/base.ini", "bar-color-sub");
    DelLine("data/base.ini", "text-color1");
    DelLine("data/base.ini", "text-color2");
    DelLine("data/base.ini", "text-color3");
    DelLine("data/base.ini", "alpha");
    DelLine("data/base.ini", "alpha-sub");

    //行の追加
    AddLine("data/base.ini", "main-color,"+hex(ThemeColor[nextSettingColor][0]));
    AddLine("data/base.ini", "sub-color,"+hex(ThemeColor[nextSettingColor][1]));
    AddLine("data/base.ini", "bar-color,"+hex(ThemeColor[nextSettingColor][2]));
    AddLine("data/base.ini", "bar-color-sub,"+hex(ThemeColor[nextSettingColor][3]));
    AddLine("data/base.ini", "text-color1,"+hex(ThemeColor[nextSettingColor][4]));
    AddLine("data/base.ini", "text-color2,"+hex(ThemeColor[nextSettingColor][5]));
    AddLine("data/base.ini", "text-color3,"+hex(ThemeColor[nextSettingColor][6]));
    AddLine("data/base.ini", "alpha,"+ThemeColor[nextSettingColor][7]);
    AddLine("data/base.ini", "alpha-sub,"+ThemeColor[nextSettingColor][8]);       

    //リロード
    LoadInitialize("base.ini");

    //移動
    MasterFlg = 5;
  }
  textSet(Font001, 24, LEFT, TOP);
  for (int i = 0; i < ThemeColor.length; i++) {
    if (ThemeColor[i][0] != -1) {
      if (mouseX > 1 && mouseX < 479 && mouseY > PosY+1 && mouseY < PosY+71 && mouseY > 72) {
        frect(1, PosY+1, 478, 70, ThemeColor[i][1], 128);
        if (mouseKey == 1) nextSettingColor = i;
      }
      frect(1, PosY+1, 478, 70, ThemeColor[i][0], 128);
      ftextb(ThemeMoji[i], 20, PosY+20, ThemeColor[i][5], ThemeColor[i][4]);
      for (int j = 0; j < 6; j++) frect( 250+j*33, PosY+32, 32, 32, ThemeColor[i][j], 255);
      PosY = PosY + 72;
    }
  }

  pPosY = PosY-72-ScrollSettingColor;

  //キャンセル
  noTint();
  image(Img000, 0, 0);
  if (CancelButton()) MasterFlg = 5;
}

//初期化
int[][] ThemeColor;
String[] ThemeMoji;
void SettingColorInitialize() {
  //取得
  String[] extensions = {".them"};
  File cdirectory = new File(dataPath("theme"));
  File[] fileList = cdirectory.listFiles();

  //ロード
  ThemeColor = new int[fileList.length][9];
  ThemeMoji = new String[fileList.length];
  for (int i = 0; i < fileList.length; i++) {
    ThemeColor[i][0] = -1;
    for (String extension : extensions) {
      if (fileList[i].getPath().endsWith(extension)) {
        //ロード
        ThemeMoji[i] = "文字見本";
        String[] Load = loadStrings(fileList[i]);
        for (String a : Load) {
          String[] Temp = split(a, ",");
          if (Temp[0].equals("main-color")) ThemeColor[i][0] = int(unhex(Temp[1]));
          if (Temp[0].equals("sub-color")) ThemeColor[i][1] = int(unhex(Temp[1]));
          if (Temp[0].equals("bar-color")) ThemeColor[i][2] = int(unhex(Temp[1]));
          if (Temp[0].equals("bar-color-sub")) ThemeColor[i][3] = int(unhex(Temp[1]));
          if (Temp[0].equals("text-color1")) ThemeColor[i][4] = int(unhex(Temp[1]));
          if (Temp[0].equals("text-color2")) ThemeColor[i][5] = int(unhex(Temp[1]));
          if (Temp[0].equals("text-color3")) ThemeColor[i][6] = int(unhex(Temp[1]));
          if (Temp[0].equals("alpha")) ThemeColor[i][7] = int(Temp[1]);
          if (Temp[0].equals("alpha-sub")) ThemeColor[i][8] = int(Temp[1]);
          if (Temp[0].equals("name")) ThemeMoji[i] = Temp[1];
        }
      }
    }
  }
}

// ====================================================================================================================================================================================================================================================
//設定画面の初期化
String[] SettingMsg = {"＊設定＊", "テーマカラー", "カレンダーの背景", "セレクト画面の背景", "＊スケジュール＊", "科目の追加"};
int[] SettingType = {0, 1, 1, 1, 0, 1};
int[] SettingJump = {-1, 30, 601, 602, -1, 32};

//設定画面のマスター
void MasterSetting() {
  //初期化
  if (SubCount == 0) {
    BeforeFlg = MasterFlg;
    BefireFlgNewSubject = MasterFlg;
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //毎ループの初期化
  int PosY = 72;

  //項目
  for (int i = 0; i < SettingType.length; i++) {
    switch(SettingType[i]) {
    case 0:
      frect(2, PosY+2, 476, 30, BarColor, FillAlpha);
      textSet(Font001, 18, LEFT, CENTER);
      ftextb(SettingMsg[i], 18, PosY+18, TextColor[1], TextColor[0]);
      PosY = PosY + 32;
      break;
    case 1:
      if (mouseX > 2 && mouseX < 478 && mouseY > PosY+2 && mouseY < PosY+60) {
        frect(2, PosY+2, 476, 62, BarColorSub, FillAlphaSub);
        if (mouseKey == 1) {
          mouseKey = 2;
          MasterFlg = SettingJump[i];//ここで画面変更
        }
      } else frect(2, PosY+2, 476, 62, BarColorSub, FillAlpha);
      textSet(Font001, 26, LEFT, CENTER);
      ftextb(SettingMsg[i], 32, PosY+32, TextColor[1], TextColor[0]);
      PosY = PosY + 64;
      break;
    }
  }

  //上部タブ
  frect(2, 2, 476, 70, SubColor, FillAlphaSub);

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

// ====================================================================================================================================================================================================================================================
//科目の選択
//初期化
int SubjectFlg = 0;  //0-修正 1-選択
int SubjectScroll = 0;
int SubjectSelect = -1;
String SubjectUpDate = "";

//課題のセットと修正
void MasterSubject() {
  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //初期化
  int PosY = 144 - SubjectScroll;

  //スクロールの処理
  if (mouseKey != 0 && abs(mouseX - pmouseX) > 1) mouseKey = 3;  //指定の仕方がめっちゃ雑い
  if (mouseKey == 3) SubjectScroll = SubjectScroll - (mouseY - pmouseY);
  if (72*SubjectList.length - 460 < SubjectScroll) SubjectScroll = 72*SubjectList.length - 460;
  if (SubjectScroll < 0) SubjectScroll = 0;

  //科目リストと決定処理
  if (mouseKey == 3) SubjectSelect = -1;
  if (SubjectSelect != -1 && mouseKey == 0) {
    MasterFlg = BeforeFlgSubject;//ここで画面変更
    SubjectUpDate = SubjectList[SubjectSelect];
  }
  for (int i = 0; i < SubjectList.length; i++) {
    if (mouseY > PosY+1 && mouseY < PosY+71 && mouseX > 1 && mouseX < 479 && mouseY > 144) {
      if (mouseKey == 1) {
        frect(1, PosY+1, 478, 70, MainColor, FillAlphaSub);
        SubjectSelect = i;
      } else frect(1, PosY+1, 478, 70, MainColor, FillAlpha);
    }
    BarSubject(SubjectList[i], PosY, -1, "");
    PosY = PosY + 72;
  }

  //戻るボタン
  tint(FillAlphaSub);
  image(ImgBackground.get(0, 0, 480, 143), 0, 0);
  if (mouseY < 62 && mouseY > 2 && mouseX > 2 && mouseX < 478 && mouseKey != 3) {
    frect(2, 2, 476, 70, SubColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      MasterFlg = BeforeFlgSubject;//ここで画面変更
    }
  } else frect(2, 2, 476, 70, SubColor, FillAlpha);
  textSet(Font001, 32, CENTER, CENTER);
  ftextb("戻る", 240, 36, TextColor[1], TextColor[0]);

  //新規作成ボタン
  MakeNewSubject(84, MasterFlg);
}

// ====================================================================================================================================================================================================================================================
//イメージの選択
int MasterSelectImageFlg = 0;
PImage[] ImageList;
String[] ImageName;
int SelectImageScroll = 0, pPosY = 0, SelectImage = -1;
void MasterSelectImage() {

  //リストの作成
  if (SubCount == 0) {
    SelectImageScroll = 0;
    SelectImage = -1;
    String[] extensions = {".png", ".jpg", ".bmp"};
    File cdirectory = new File(dataPath("image"));
    File[] fileList = cdirectory.listFiles();
    ImageList = new PImage[fileList.length];
    ImageName = new String[fileList.length];
    for (int i = 0; i < fileList.length; i++) for (String extension : extensions) if (fileList[i].getPath().endsWith(extension)) {
      ImageList[i] = loadImage(fileList[i].getAbsolutePath());
      ImageName[i] = "data/image/"+fileList[i].getName();
    }
  }

  //背景
  background(MainColor);

  //スクロール
  if (mouseKey == 1 && abs(mouseY - pmouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) SelectImageScroll = SelectImageScroll - (pmouseY - mouseY);
  if (SelectImageScroll < 320-pPosY) SelectImageScroll = 320-pPosY;
  if (SelectImageScroll > 0) SelectImageScroll = 0;

  //リストの表示＆処理
  if (mouseKey == 3) SelectImage = -1;
  if (mouseKey == 0 && SelectImage != -1) {
    if (MasterSelectImageFlg == 0) { 
      DelLine("data/base.ini", "backgroung-img");
      AddLine("data/base.ini", "backgroung-img,"+ImageName[SelectImage]);
    } else { 
      DelLine("data/base.ini", "backgroung-img-sub");
      AddLine("data/base.ini", "backgroung-img-sub,"+ImageName[SelectImage]);
    }
    LoadInitialize("data/base.ini");               //設定のロード
    MasterFlg = 5;
  }
  int PosX = 0, PosY = 0;
  for (int i = 0; i < ImageName.length; i++) if (ImageName[i].equals("") == false) {
    tint(255, 96);
    if (mouseX > PosX*220+40 && mouseX < PosX*220+40+180 && mouseY > PosY*260+96+SelectImageScroll && mouseY < PosY*260+96+SelectImageScroll+240 && mouseY > 64) {
      tint(255, 255);
      if (mouseKey == 1) SelectImage = i;
    }
    image(ImageList[i], PosX*220+40, PosY*260+96+SelectImageScroll, 180, 240);
    if (PosX == 0) PosX = PosX + 1;
    else {
      PosX = 0;
      PosY = PosY + 1;
    }
  }
  pPosY = PosY*260+96;

  //キャンセル
  frect(0, 0, 480, 64, MainColor, 255);
  if (CancelButton()) MasterFlg = 5;
}

// ====================================================================================================================================================================================================================================================
//時間の入力
//学習時間の入力
void MasterInputTime() {
  //初期化
  if (SubCount == 0) {
    Img000 = ImgBefore.get();
  }

  //背景
  background(#000000);
  tint(64);
  image(Img000, 0, 0);

  //完了
  if (CompleteButton()) {
    DelLine2("data/schedule/data.csv", SettingHomeworkpData);//削除
    SettingHomeworkpData = (SettingHomeworkYear+"/"+SettingHomeworkMonth+"/"+SettingHomeworkDay)+","+(SettingHomeworkHour+":"+SettingHomeworkMinute)+","+SettingHomeworkSubject+","+SettingHomeworkPar+","+SettingHomeworkStudyTime+","+SettingHomeworkMemo;
    AddLine("data/schedule/data.csv", SettingHomeworkpData);//新規作成
    LoadSchedule("data/schedule/data.csv");   //スケジュールのリロード
    MasterFlg = BeforeFlg;
  }

  //描画と処理
  int NowAng = int(SettingHomeworkStudyTime*360/24);
  fellipse(240, 320, 300, 300, TextColor[2], FillAlphaSub);
  fdrawPi(240, 320, 300, 0.5, 0.5+(0.0+NowAng)/360, MainColor, FillAlphaSub);
  fellipse(240, 320+150, 16, 16, TextColor[0], FillAlphaSub);
  fellipse(240, 320+150, 12, 12, MainColor, FillAlphaSub);
  fellipse(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), 24, 24, TextColor[0], FillAlphaSub);
  fellipse(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), 20, 20, MainColor, FillAlphaSub);
  if (kyori(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), mouseX, mouseY) < 18 || mouseKey == 3) {
    fellipse(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), 20, 20, TextColor[1], FillAlphaSub);
    if (mouseKey == 1) mouseKey =3;
  }
  if (mouseKey == 3) { 
    SettingHomeworkStudyTime = (360+180-degrees(atan2(240-mouseX, 320-mouseY)))%360*48/360;
    if (int(SettingHomeworkStudyTime)%2 == 0) SettingHomeworkStudyTime = 0.0 + int(SettingHomeworkStudyTime/2);
    else SettingHomeworkStudyTime = 0.0 + int(SettingHomeworkStudyTime/2) + 0.5;
  }
  if (SettingHomeworkStudyTime < 0) SettingHomeworkStudyTime = 0;
  if (SettingHomeworkStudyTime > 24) SettingHomeworkStudyTime = 24;
  String a = "0";
  if ((SettingHomeworkStudyTime*2)%2 == 1) a = "5";
  textSet(Font001, 48, CENTER, CENTER);
  ftextb(nf(int(SettingHomeworkStudyTime), 2)+"."+a+"h", 240, 320, TextColor[1], TextColor[0]);
}