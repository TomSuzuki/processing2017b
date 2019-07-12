//設定画面の初期化
String[] SettingMsg = {"＊設定＊", "テーマカラー", "機能の背景", "メインの背景", "パスワードの変更", "天気予報の場所", "詳細設定" ,"＊スケジュール＊", "科目の追加"};
int[] SettingType = {0, 1, 1, 1, 1, 1, 1, 0, 1};
int[] SettingJump = {-1, 30, 601, 602, 50, 801, 900, -1, 32};
int MasterSettingNext = -1, MasterSettingScroll = 0, MasterSettingScrollMax = 0;

//設定画面のマスター
void MasterSetting() {
  //初期化
  if (SubCount == 0) {
    BeforeFlg = MasterFlg;
    BefireFlgNewSubject = MasterFlg;
    MasterSettingNext = -1;
    MasterSettingScroll = 0;
    MasterSettingScrollMax = 0;
    Img000 = ImgBackground.get(0, 0, 480, 72);
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //スクロール
  if (mouseKey == 1 && abs(pmouseY - mouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) MasterSettingScroll = MasterSettingScroll + (pmouseY - mouseY);
  if (MasterSettingScrollMax - 180 < MasterSettingScroll) MasterSettingScroll = MasterSettingScrollMax - 180;
  if (MasterSettingScroll < 0) MasterSettingScroll = 0;

  //毎ループの初期化
  int PosY = 72 - MasterSettingScroll;

  //項目
  if (mouseKey == 3) MasterSettingNext = -1;
  if (MasterSettingNext != -1 && mouseKey == 0) MasterFlg = MasterSettingNext;
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
        if (mouseKey == 1) MasterSettingNext = SettingJump[i];//ここで画面変更
      } else frect(2, PosY+2, 476, 62, BarColorSub, FillAlpha);
      textSet(Font001, 26, LEFT, CENTER);
      ftextb(SettingMsg[i], 32, PosY+32, TextColor[1], TextColor[0]);
      PosY = PosY + 64;
      break;
    }
  }
  MasterSettingScrollMax = PosY + MasterSettingScroll;

  //上部タブ
  image(Img000, 0, 0);
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