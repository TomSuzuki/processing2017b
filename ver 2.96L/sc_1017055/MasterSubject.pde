//科目の選択
//初期化
int SubjectFlg = 0;  //0-修正 1-選択
int SubjectScroll = 0;
int SubjectSelect = -1;
String SubjectUpDate = "";

//課題のセットと修正
void MasterSubject() {
  //初期化
  if (SubCount == 0){
    Img000 = ImgBackground.get(0, 0, 480, 143);
  }

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
    BarSubject(SubjectList[i], PosY, -1, "", "");
    PosY = PosY + 72;
  }

  //戻るボタン
  tint(FillAlphaSub);
  image(Img000, 0, 0);
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
  MakeNewButton(84, MasterFlg, 2);
}