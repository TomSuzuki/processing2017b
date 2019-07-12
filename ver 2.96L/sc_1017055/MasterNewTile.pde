//Tile関連
//Tileの設定
String[] TileSettingMsg = {"＊追加＊", "新しいウェブリンク", "新しいアプリリンク"};
int[] TileSettingType = {0, 1, 1};
int[] TileSettingJump = {-1, 701, 702};
void MasterTile() {

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //毎ループの初期化
  int PosY = 72;

  //項目
  for (int i = 0; i < TileSettingType.length; i++) {
    switch(TileSettingType[i]) {
    case 0:
      frect(2, PosY+2, 476, 30, BarColor, FillAlpha);
      textSet(Font001, 18, LEFT, CENTER);
      ftextb(TileSettingMsg[i], 18, PosY+18, TextColor[1], TextColor[0]);
      PosY = PosY + 32;
      break;
    case 1:
      if (mouseX > 2 && mouseX < 478 && mouseY > PosY+2 && mouseY < PosY+60) {
        frect(2, PosY+2, 476, 62, BarColorSub, FillAlphaSub);
        if (mouseKey == 1) {
          mouseKey = 2;
          MasterFlg = TileSettingJump[i];//ここで画面変更
        }
      } else frect(2, PosY+2, 476, 62, BarColorSub, FillAlpha);
      textSet(Font001, 26, LEFT, CENTER);
      ftextb(TileSettingMsg[i], 32, PosY+32, TextColor[1], TextColor[0]);
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


//リンクタイルの作成 --------------------------------------------------------------------------------------------------------------
String LinkURLorPASS = "", LinkTitle = "";
int LinkFlg = 0;
int LinkTextEditFlg = -1;
void NewLinkTile() {

  //初期化
  if (SubCount == 0) {
    //キーボードからの帰り
    if (KeyBodeUpDate.equals("") == false) {
      if (LinkTextEditFlg == 2) LinkURLorPASS = KeyBodeUpDate.substring(1, KeyBodeUpDate.length());
      else LinkTitle = KeyBodeUpDate.substring(1, KeyBodeUpDate.length());
      KeyBodeUpDate = "";
    } else {
      LinkURLorPASS = "";
      LinkTitle = "";
    }
    LinkTextEditFlg = -1;
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //文字（タイトル）
  if (mouseX > 60 && mouseX < 420 && mouseY > 180 && mouseY < 216) {  
    frect(60, 180, 360, 36, MainColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      LinkTextEditFlg = 1;

      BeforeFlgMemo = MasterFlg;
      MasterFlg = 11;
      KeyBodeUnsettled = "";
      KeyBodeDraw = LinkTitle;
      NowLine = KeyBodeDraw.length();
    }
  }
  frect(60, 180, 360, 36, BarColor, FillAlphaSub);
  textSet(Font001, 24, LEFT, BOTTOM);
  if (LinkTitle.equals("")) ftextb("タイル名を設定してください。", 70, 180+32, TextColor[1], TextColor[0]);
  else if (LinkTitle.length() > 16) ftextb(LinkTitle.substring(0, 15)+"...", 70, 180+32, TextColor[1], TextColor[0]);
  else ftextb(LinkTitle, 70, 180+32, TextColor[1], TextColor[0]);

  //文字（パス）
  if (mouseX > 60 && mouseX < 420 && mouseY > 260 && mouseY < 296) {  
    frect(60, 260, 360, 36, MainColor, FillAlphaSub);
    if (mouseKey == 1) {
      mouseKey = 2;
      LinkTextEditFlg = 2;

      BeforeFlgMemo = MasterFlg;
      MasterFlg = 11;
      KeyBodeUnsettled = "";
      KeyBodeDraw = LinkURLorPASS;
      NowLine = KeyBodeDraw.length();
    }
  }
  frect(60, 260, 360, 36, BarColor, FillAlphaSub);
  textSet(Font001, 12, LEFT, BOTTOM);
  if (LinkURLorPASS.equals("")) ftextb("タイルのパスを設定してください。", 70, 260+32, TextColor[1], TextColor[0]);
  else if (LinkURLorPASS.length() > 28) ftextb(LinkURLorPASS.substring(0, 26)+"...", 70, 260+32, TextColor[1], TextColor[0]);
  else ftextb(LinkURLorPASS, 70, 260+32, TextColor[1], TextColor[0]);

  //キャンセル||完了
  switch(CompleteButton(LinkURLorPASS.equals("")==false && LinkTitle.equals("")==false)) {
  case 1://キャンセル
    MasterFlg = BeforeFlg;
    break;
  case 2://完了
    //座標どこにする
    int maxY = 0;
    MakeFileNoFile(FileDataTile, default_FileDataTile);
    String[] f = loadStrings(FileDataTile);
    for (int i = 0; i < f.length; i++) {
      String[] Temp = split(f[i], ",");
      if (Temp.length > 1) if (maxY < int(Temp[1])) maxY = int(Temp[1]);
    }

    //追加
    AddLine(FileDataTile, "0,"+(maxY+1)+","+LinkTitle+","+(LinkFlg+300));

    //パス
    String[] a = {LinkURLorPASS};
    saveStrings(FolderLinks+LinkTitle+".txt", a);

    MasterFlg = BeforeFlg;
    break;
  }
}