//セレクトの初期化
int SelectTime = 0, SelectTimeR = 31;
int[][] TileSet, TileLoad;
String[] TileName;
int SelectNext = -1, SelectDel = -1, SelectChange = -1, SCX = 1;
int SelectAddY = 0, SelectAddX = 0;
int MaxY = -1;
int MsgX = 0;
String NowHomeworkList = "", NowHomeworkList2 = "";
String MsgEventTile = "";
void ResetSelect() {
  //初期化
  SelectTime = 0;//修正する場所

  //移動処理
  BeforeFlgSelect = MasterFlg;
  MasterFlg = 0;
}

//セレクト
void MasterSelect() {
  //初期化
  if (SubCount == 0) {    
    SelectDel = -1;//消すタイルのID
    SelectChange = -1;//移動する(ry

    SelectYear = year();
    SelectMonth = month();
    SelectDay = day();
  }

  //背景画像の生成＆初期化など
  if (SelectTime == 0) {
    Img000 = ImgBefore;
    ImgTAB = ImgBackgroundSub.get(0, 0, 480, 48);
    MsgX = 0;
    //タイルのロード
    TileLoad();

    SelectNext = -1;
    SelectAddY = 0;
    SelectAddX = 0;
    NowHomeworkList = "";
    NowHomeworkList2 = "";
    int num = 0;
    for (int i = 0; i < ScheduleDate.length; i++) {
      if ((yesterday(ScheduleDate[i]).equals(year()+"/"+month()+"/"+day()) || ScheduleDate[i].equals(year()+"/"+month()+"/"+day())) && SchedulePercent[i] != 1) {
        if (NowHomeworkList.equals("")) NowHomeworkList = "明日までの未完了課題は";
        if (num < 3) NowHomeworkList2 = NowHomeworkList2 + ScheduleDate[i] + "   " + ScheduleSubject[i] + "\n";
        num = num + 1;
        NowHomeworkList = NowHomeworkList + "、" + ScheduleSubject[i];
      }
    }
    if (num > 3) NowHomeworkList2 = NowHomeworkList2 + "ほか"+(num-3)+"件の課題があります。";
    if (NowHomeworkList.equals("")) NowHomeworkList = "明日までの課題はありません。";
    else NowHomeworkList = NowHomeworkList + "があります。";
    if (NowHomeworkList2.equals("")) NowHomeworkList2 = "明日までの課題はありません。";

    //イベント
    num = 0;
    MsgEventTile = "";
    for (int i = 0; i < EventDate.length; i++) {
      if ((yesterday(EventDate[i]).equals(year()+"/"+month()+"/"+day()) || EventDate[i].equals(year()+"/"+month()+"/"+day()))) {
        if (NowHomeworkList.equals("")) MsgEventTile = "明日までのイベントは";
        if (num < 3) MsgEventTile = MsgEventTile + EventDate[i] + "   " + EventName[i] + "\n";
        num = num + 1;
      }
    }
    if (num > 3) MsgEventTile = MsgEventTile + "ほか"+(num-3)+"件のイベントがあります。";
    if (MsgEventTile.equals("")) MsgEventTile = "明日までのイベントはありません。";
  }

  //処理
  SelectTime = SelectTime + int(1*frameRateSpeed);

  //スクロールの処理
  if (SelectTime <= 30) translate(easing(SelectTime, 30, -480, 0, 103), 0);

  //スクロール
  if (mouseKey == 1 && abs(mouseY - pmouseY) > 1 && SelectAddX != 480) mouseKey = 3;
  if (mouseKey == 1 && abs(mouseX - pmouseX) > 1) mouseKey = 7;
  if (mouseKey == 3) SelectAddY = SelectAddY + (mouseY - pmouseY);
  if (mouseKey == 7) SelectAddX = SelectAddX + (mouseX - pmouseX);
  else if (SelectAddX < 240) SelectAddX = SelectAddX - int(easing(SelectAddX, 485, 5, 12, 2)*frameRateSpeed);
  else SelectAddX = SelectAddX + int(easing(480-SelectAddX, 485, 5, 12, 2)*frameRateSpeed);
  if (SelectAddY < -(MaxY*120)+320) SelectAddY = -(MaxY*120)+320;
  if (SelectAddX > 480) SelectAddX = 480;
  if (SelectAddY > 0) SelectAddY = 0;
  if (SelectAddX < 0) SelectAddX = 0;
  translate(SelectAddX, 0);

  //背景
  if (OptionTileImage == false){
    frect(0, 0, 480, 640, MainColor, 255);
    tint(FillAlphaSub);
    image(ImgBackgroundSub, 0, 0);
  }else{
    background(MainColor);
  }

  //マイループの(ry
  int PosY = 0, PosX;
  MaxY = -1;

  //タイル
  if (mouseKey == 3 || mouseKey == 7) {
    SelectNext = -1;
    SelectDel = -1;
    SelectChange = -1;//←で例外？mouseKey変更？（下で変更することにした）
  }
  if (SelectNext > 0 && mouseKey == 0) { 
    MasterFlg = SelectNext;
    SelectTimeR = 0;
  }
  if (SelectDel != -1 && mouseKey == 0) {
    MasterFlg = 705;
  }
  if (mouseKey == 0) SelectChange = -1;
  if (mouseKey != 12) {
    if (SelectChange != -1) {/*ここ作ってる途中*/
      //SelectChange==0じゃないなら0に持ってくる
      mouseKey = 12;
      int a;
      String b;
      //上に持ってくる
      for (int c = 0; c < 3; c++) {
        a = TileLoad[SelectChange][c];
        TileLoad[SelectChange][c] = TileLoad[0][c];
        TileLoad[0][c] = a;
      }
      b = TileName[SelectChange];
      TileName[SelectChange] = TileName[0];
      TileName[0] = b;

      //一番上除いて並べ替え
      for (int i = 1; i < TileLoad.length; i++) for (int j = 1; j < TileLoad.length; j++) {
        if (TileLoad[i][1] < TileLoad[j][1]) {

          for (int c = 0; c < 3; c++) {
            a = TileLoad[i][c];
            TileLoad[i][c] = TileLoad[j][c];
            TileLoad[j][c] = a;
          }
          b = TileName[i];
          TileName[i] = TileName[j];
          TileName[j] = b;
        }
      }
    }
  } else {
    //移動処理とかやって上から調べた時に空いている行があったら...面倒だしいいか...
    //SCXにXのサイズが入っている
    //横移動したら下にずれる（ここは違和感あっても動けばいい）

    //座標変換
    int cx = (mouseX-60*SCX)/120;
    int cy = (mouseY-SelectAddY-48)/120;
    if (cy < 0) cy = 0;
    if (cx < 0) cx = 0;
    if (cx > 4-SCX) cx = 4-SCX;

    //場所変更処理
    TileLoad[0][0] = cx;
    TileLoad[0][1] = cy;

    //重なったら下に移動って処理
    int[][] UsePos = new int[4][128];//行増やしすぎると（ry
    for (int i = 0; i < TileLoad.length; i++) {
      //個々の処理
      int sx = 1, ny = TileLoad[i][1];
      int flg = 0;
      if (TileLoad[i][2] == -10 || TileLoad[i][2] == 1 || TileLoad[i][2] ==  2 || TileLoad[i][2] == 120) sx = 2;
      while (flg == 0) {
        flg  = 1;
        for (int j = 0; j < sx; j++) if (j+TileLoad[i][0] < 4) if (UsePos[j+TileLoad[i][0]][ny] == 1) flg = 0;
        if (flg == 0) ny = ny + 1;
      }
      //空いているだけ上に詰める
      if (ny == TileLoad[i][1] && i != 0) {
        flg = 0;
        while (flg == 0) {
          flg = 0;
          for (int j = 0; j < sx; j++) if (j+TileLoad[i][0] < 4) if (UsePos[j+TileLoad[i][0]][ny] == 1) flg = 1;
          if (flg == 0) ny = ny - 1;
          if (ny == -1) flg = 1;
        }
        ny = ny + 1;
      }
      //ずらす
      TileLoad[i][1] = ny;
      for (int j = 0; j < sx; j++) if (j+TileLoad[i][0] < 4) UsePos[j+TileLoad[i][0]][ny] = 1;
    }

    //描画
    frect(mouseX-120*SCX, mouseY, 120*SCX, 120, BarColor, 255);

    //保存
    String[] a = new String[TileLoad.length];
    for (int i = 0; i < a.length; i++) a[i] = TileLoad[i][0]+","+TileLoad[i][1]+","+TileName[i]+","+TileLoad[i][2];
    saveStrings(FileDataTile, a);
  }

  //Tileの処理＆描画
  for (int i = 0; i < TileLoad.length; i++) {
    PosX = (SelectChange != -1 && 0 == i) ? mouseX-120*SCX : TileLoad[i][0]*120;
    PosY = (SelectChange != -1 && 0 == i) ? mouseY-SelectAddY : TileLoad[i][1]*120+48;
    TileDrawRun(PosX, PosY, TileName[i], TileLoad[i][2], SelectAddY, i);
    if (PosY > MaxY) MaxY = PosY;
  }
  MaxY = (MaxY+120)/120;

  //追加タイル（仮）
  TileDrawRun(0, MaxY*120+48, "タイルの追加", 700, SelectAddY, -1);

  //上部タブ
  if (OptionTileImage == false) {
    image(ImgTAB, 0, 0);
    frect(1, 1, 478, 46, MainColor, FillAlphaSub);
  } else {
    frect(0,0,480,48,MainColor,255);
    image(ImgBackgroundSub.get(1,1,478,46),1,1);
  }
  textSet(Font002, 16, LEFT, CENTER);
  MsgX = MsgX - int(1*frameRateSpeed);
  if (textWidth(NowHomeworkList) > 460) {
    if (textWidth(NowHomeworkList)+50 + MsgX < 0) MsgX = 0;    
    ftextb(NowHomeworkList, MsgX, 24, TextColor[1], TextColor[0]);
    ftextb(NowHomeworkList, int(MsgX+textWidth(NowHomeworkList)+50), 24, TextColor[1], TextColor[0]);
  } else {
    if (480 + MsgX < 0) MsgX = 0;
    ftextb(NowHomeworkList, MsgX, 24, TextColor[1], TextColor[0]);
    ftextb(NowHomeworkList, MsgX+480, 24, TextColor[1], TextColor[0]);
  }


  //スクロールの処理
  if (SelectTime <= 30) translate(-easing(SelectTime, 30, -480, 0, 103), 0);

  //前画面
  if (SelectTime <= 30) {
    noTint();
    image(Img000, easing(SelectTime, 30, -480, 0, 103)+480, 0);
  }

  //キャラ画面
  if (SelectAddX != 0 || SubCount == 0){
    translate(-480, 0);
    MasterCharacter();
    translate(480, 0);
  }

  //横スライド戻し
  translate(-SelectAddX, 0);
}

//タイル
//もともと面倒な処理してたんだけどわりと頑張って簡単にした
//100行以上減ったんじゃないかなぁ
void TileDrawRun(int x, int y, String name, int c, int addY, int i) {

  //初期化
  int sizeX = 1;
  boolean DelSwicth = false;
  boolean MovSwitch = true;
  boolean NexSwitch = true;
  boolean KeySwitch = false;

  //各種設定
  switch(c) {
  case -10:
    NexSwitch = false;
  case 120:
  case 2:
  case 1:
    sizeX = 2;
    break;
  case 300:
  case 301:
    DelSwicth = true;
    break;
  case 700:
    MovSwitch = false;
    break;
  }

  //描画＆処理
  if (mouseX-SelectAddX > x+1 && mouseX-SelectAddX < x+1+sizeX*120-2 && mouseY > y+1+addY && mouseY < y+1+118+addY && mouseY > 48 && mouseX-SelectAddX > 0) {
    if (OptionTileImage) {
      tint(FillAlpha);
      image(ImgBackgroundSub.get(x+1,y+1+addY,sizeX*120-2,118),x+1,y+1+addY);
      noTint();
    }else frect(x+1, y+1+addY, sizeX*120-2, 118, MainColor, FillAlpha);
    if (mouseX-SelectAddX > x+sizeX*120-20 && mouseY < y+20+addY && MovSwitch) {//移動
      frect(x+1, y+1+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
      frect(x+sizeX*120-20, y+1+addY, 20, 20, #0000FF, 255);
      textSet(Font002, 18, CENTER, CENTER);
      ftext("○", x+sizeX*120-10, y+10+addY, #FFFFFF);
      if (mouseKey == 1) {
        SelectChange = i;
        SCX = sizeX;
      }
    } else if (mouseX-SelectAddX < x+20 && mouseY < y+addY+20 && DelSwicth) {//消す
      frect(x+1, y+1+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
      frect(x+1, y+1+addY, 20, 20, #FF0000, 255);
      textSet(Font002, 18, CENTER, CENTER);
      ftext("×", x+10, y+addY+10, #FFFFFF);
      if (mouseKey == 1) SelectDel = i;
    } else if (mouseKey == 1 && NexSwitch) {
      SelectNext = c;
      KeySwitch = true;
    }
  } else {
    if (OptionTileImage) {
      tint(FillAlphaSub);
      image(ImgBackgroundSub.get(x+1,y+1+addY,sizeX*120-2,118),x+1,y+1+addY);
      noTint();
    } else frect(x+1, y+1+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
  }

  //表示＆処理
  textSet(Font002, 24, CENTER, CENTER);
  switch(c) {
  case -10://時計
    textSet(Font002, 24, CENTER, CENTER);
    ftextb(nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2), x+120, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 1://スケジュール
    textSet(Font002, 14, LEFT, TOP);
    ftextb(NowHomeworkList2, x+10, y+20+addY, TextColor[1], TextColor[0]);
    if (KeySwitch) CalendarMainNowTab = 0;
    break;
  case 2://カレンダー
    textSet(Font002, 24, LEFT, TOP);
    ftextb(year()+"年", x+10, y+20+addY, TextColor[1], TextColor[0]);
    textSet(Font002, 24, CENTER, TOP);
    ftextb(nf(month(), 2)+"月"+nf(day(), 2)+"日（"+WeekDay2[dayweek(year(), month(), day())]+"）", x+120, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 5://設定
    ftextb("設定", x+60, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 120://イベント
    textSet(Font002, 14, LEFT, TOP);
    ftextb(MsgEventTile, x+10, y+20+addY, TextColor[1], TextColor[0]);
    break;
  case 200://再起動
    ftextb("再起動", x+60, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 201://メモ
    ftextb("メモ", x+60, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 202://終了
    ftextb("終了", x+60, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 300://リンク
  case 301://リンク
    ftextb("Link", x+60, y+60+addY, TextColor[1], TextColor[0]);
    if (KeySwitch) LinkFileName = "data/link/"+name+".txt";
    break;
  case 500://記録
    ftextb("記録", x+60, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 700://追加
    textSet(Font002, 64, CENTER, CENTER);
    ftextb("＋", x+60, y+60+addY, TextColor[1], TextColor[0]);
    break;
  case 800://天気予報
    textSet(Font002, 20, CENTER, CENTER);
    ftextb(GetWeatherNowWeather, x+60, y+60+addY, TextColor[1], TextColor[0]);
    name = GetWeatherCityName;
    break;
  }

  //タイトル
  textSet(Font002, 12, LEFT, BOTTOM);
  ftextb(name, x+3, y+118+addY, TextColor[1], TextColor[0]);
}

//タイルの削除
void DeleteTile() {
  //初期化
  if (SubCount == 0) Img000 = ImgBefore.get();

  //背景
  background(#000000);
  tint(FillAlpha);
  image(Img000, 0, 0);

  //文字
  textSet(Font001, 36, CENTER, CENTER);
  ftextb("本当に削除しますか？", 240, 320, TextColor[1], TextColor[0]);

  //キャンセル||完了
  switch(CompleteButton(true)) {
  case 1://キャンセル
    MasterFlg = 0;
    break;
  case 2://完了
    //消す（タイル消してもパス残る←間違って消したらわりと面倒だから）
    DelLine2(FileDataTile, TileLoad[SelectDel][0]+","+TileLoad[SelectDel][1]+","+TileName[SelectDel]+","+TileLoad[SelectDel][2]);
    TileLoad();
    MasterFlg = 0;
    break;
  }
}

//セレクトからの復帰
void MasterSelectR() {
  //描画しなくていい
  if (SelectTimeR >= 30) return;

  //背景画像の生成
  if (SelectTimeR == 0) Img003 = get(0, 0, int(easing(SelectTime, 30, 0, 480, 3)), 640);

  //処理
  SelectTimeR = SelectTimeR + int(1*frameRateSpeed);

  //スクロールの処理
  translate(-480, 0);

  //描画
  tint(255);
  image(Img003, 0, 0);

  //スクロールの処理
  translate(480, 0);
}

void TileLoad() {
  MakeFileNoFile(FileDataTile, default_FileDataTile);
  String[] f = loadStrings(FileDataTile);
  TileLoad = new int[f.length][3];
  TileName = new String[f.length];
  for (int i = 0; i < f.length; i++) {
    String[] Temp = split(f[i], ",");
    TileLoad[i][0] = int(Temp[0]); //x
    TileLoad[i][1] = int(Temp[1]); //y 
    TileName[i] = Temp[2];         //Name
    TileLoad[i][2] = int(Temp[3]); //case
  }
}