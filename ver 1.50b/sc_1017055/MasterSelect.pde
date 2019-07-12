//セレクトの初期化
String[] SelectMsg = {"*スケジュール*", "スケジュール", "カレンダー", "課題の削除", "*設定*", "詳細設定", "再起動"};
int[] SelectType = {0, 1, 1, 1, 0, 1, 1};
int[] SelectJump = {-1, 1, 2, 0, -1, 5, -1};
int SelectTime = 0, SelectTimeR = 31;
int[][] TileSet, TileLoad;
String[] TileName;
int SelectNext = -1, SelectDel = -1, SelectChange = -1, SCX = 1;
int SelectAddY = 0;
int MaxY = -1;
int MsgX = 0;
String NowHomeworkList = "", NowHomeworkList2 = "";
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
    if (NowHomeworkList.equals("")) NowHomeworkList = "明日までの課題はありません。";
    else NowHomeworkList = NowHomeworkList + "があります。";
    if (NowHomeworkList2.equals("")) NowHomeworkList2 = "明日までの課題はありません。";
  }

  //処理
  SelectTime = SelectTime + 1;

  //スクロールの処理
  if (SelectTime <= 30) translate(easing(SelectTime, 30, -480, 0, 103), 0);

  //背景
  frect(0, 0, 480, 640, MainColor, 255);
  tint(FillAlphaSub);
  image(ImgBackgroundSub, 0, 0);

  //スクロール
  if (mouseKey == 1 && abs(mouseY - pmouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) SelectAddY = SelectAddY + (mouseY - pmouseY);
  if (SelectAddY < -(MaxY*120)+320) SelectAddY = -(MaxY*120)+320;
  if (SelectAddY > 0) SelectAddY = 0;

  //マイループの(ry
  int PosY = 0, PosX;
  MaxY = -1;

  //タイル
  if (mouseKey == 3) {
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
      if (TileLoad[i][2] == -10 || TileLoad[i][2] == 1 || TileLoad[i][2] ==  2) sx = 2;
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
    saveStrings("data/data/tile.txt", a);
  }

  //Tileの処理＆描画
  for (int i = 0; i < TileLoad.length; i++) {
    PosX = TileLoad[i][0];
    PosY = TileLoad[i][1];
    TileDrawRun(PosX, PosY, TileName[i], TileLoad[i][2], SelectAddY, i);
    if (PosY > MaxY) MaxY = PosY;
  }
  MaxY = MaxY + 1;

  //追加タイル（仮）
  TileDrawRun(0, MaxY, "タイルの追加", 700, SelectAddY, -1);

  //上部タブ
  image(ImgTAB, 0, 0);
  frect(1, 1, 478, 46, MainColor, FillAlphaSub);
  textSet(Font002, 16, LEFT, CENTER);
  MsgX = MsgX - 1;
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
    //image(Img000, easing(SelectTime, 30, -480, 0, 103)+480, 0);
  }
}

//タイル
void TileDrawRun(int x, int y, String name, int c, int addY, int i) {
  int sizeX = 1;
  switch(c) {
  case -10://デジタル時計
    sizeX = 2;
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    //文字
    textSet(Font002, 24, CENTER, CENTER);
    ftextb(nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2), x*120+120, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 700://タイルの追加
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {
      frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
      if (mouseKey == 1) SelectNext = c;
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    textSet(Font002, 64, CENTER, CENTER);
    ftextb("＋", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 1://スケジュール
    sizeX = 2;
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    //文字
    textSet(Font002, 14, LEFT, TOP);
    ftextb(NowHomeworkList2, x*120+10, 120*y+20+48+addY, TextColor[1], TextColor[0]);
    break;
  case 2://カレンダー
    sizeX = 2;
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    //文字
    textSet(Font002, 24, LEFT, TOP);
    ftextb(year()+"年", x*120+10, 120*y+20+48+addY, TextColor[1], TextColor[0]);
    textSet(Font002, 24, CENTER, TOP);
    ftextb(nf(month(), 2)+"月"+nf(day(), 2)+"日（"+WeekDay2[dayweek(year(), month(), day())]+"）", x*120+120, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 5://設定
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("設定", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 200://再起動
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("再起動", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 201://メモ機能（本体未実装）
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("メモ", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 202://終了
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("終了", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 300://リンク
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        if (mouseX < x*120+20 && mouseY < 120*y+48+addY+20) {
          frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
          frect(x*120+1, 120*y+1+48+addY, 20, 20, #FF0000, 255);
          textSet(Font002, 18, CENTER, CENTER);
          ftext("×", x*120+10, 120*y+48+addY+10, #FFFFFF);
          if (mouseKey == 1) SelectDel = i;
        } else {
          frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
          if (mouseKey == 1) {
            LinkFileName = "data/link/"+name+".txt";
            SelectNext = c;
          }
        }
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    //ここに画像を
    //image(Img003, x*120+1, 120*y+1+48+addY);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("Link", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  case 301://ランチャー
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        if (mouseX < x*120+20 && mouseY < 120*y+48+addY+20) {
          frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
          frect(x*120+1, 120*y+1+48+addY, 20, 20, #FF0000, 255);
          textSet(Font002, 18, CENTER, CENTER);
          ftext("×", x*120+10, 120*y+48+addY+10, #FFFFFF);
          if (mouseKey == 1) SelectDel = i;
        } else {
          frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
          if (mouseKey == 1) {
            LinkFileName = "data/link/"+name+".txt";
            SelectNext = c;
          }
        }
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    //ここに画像を
    //image(Img003, x*120+1, 120*y+1+48+addY);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("Link", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;  
  case 500://記録
    if (mouseX > x*120+1 && mouseX < x*120+1+sizeX*120-2 && mouseY > 120*y+1+48+addY && mouseY < 120*y+1+48+118+addY && mouseY > 48) {      
      if (mouseX > x*120+sizeX*120-20 && mouseY < 120*y+20+48+addY) {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
        frect(x*120+sizeX*120-20, 120*y+1+48+addY, 20, 20, #0000FF, 255);
        textSet(Font002, 18, CENTER, CENTER);
        ftext("○", x*120+sizeX*120-10, 120*y+10+48+addY, #FFFFFF);
        if (mouseKey == 1) {
          SelectChange = i;
          SCX = sizeX;
        }
      } else {
        frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlpha);
        if (mouseKey == 1) SelectNext = c;
      }
    } else frect(x*120+1, 120*y+1+48+addY, sizeX*120-2, 118, MainColor, FillAlphaSub);
    textSet(Font002, 24, CENTER, CENTER);
    ftextb("記録", x*120+60, 120*y+60+48+addY, TextColor[1], TextColor[0]);
    break;
  }
  //タイトル
  textSet(Font002, 12, LEFT, BOTTOM);
  ftextb(name, x*120+3, 120*y+118+48+addY, TextColor[1], TextColor[0]);
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
    DelLine2("data/data/tile.txt", TileLoad[SelectDel][0]+","+TileLoad[SelectDel][1]+","+TileName[SelectDel]+","+TileLoad[SelectDel][2]);
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
  //if (SelectTimeR == 0) Img003 = get(0, 0, int(easing(SelectTime, 30, 0, 480, 3)), 640);

  //処理
  SelectTimeR = SelectTimeR + 1;

  //スクロールの処理
  //translate(easing(SelectTimeR, 30, 0, -480, 103), 0);
  translate(-480, 0);

  //描画
  tint(255);
  //image(Img003, 0, 0);

  //スクロールの処理
  //translate(-easing(SelectTimeR, 30, 0, -480, 103), 0);
  translate(480, 0);
}

void TileLoad() {    
  String[] f = loadStrings("data/data/tile.txt");
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
