//メモ
//メモ機能
String[] MemoMain;
String[] MemoName;
int[] MemoX;
int[] MemoY;
int[] MemoF;
String pMemoName = "";
int MemoScroll = 0, MemoNext = -1;
int DelMemo = -1;
void MasterMemo() {

  //キーボードから戻ってきた
  if (KeyBodeUpDate.equals("") == false) {
    String[] a = {KeyBodeUpDate.substring(1, KeyBodeUpDate.length())};
    saveStrings(pMemoName, a);
    KeyBodeUpDate = "";
  }

  //初期化
  if (SubCount == 0) {
    String[] extensions = {".txt"};
    File cdirectory = new File(dataPath("memo"));
    File[] fileList = cdirectory.listFiles();
    MemoMain = new String[fileList.length];
    MemoName = new String[fileList.length];
    MemoX = new int[fileList.length];
    MemoF = new int[fileList.length];
    MemoY = new int[fileList.length];
    for (int i = 0; i < fileList.length; i++) for (String extension : extensions) if (fileList[i].getPath().endsWith(extension)) {
      String[] a = loadStrings(fileList[i].getAbsolutePath());
      MemoMain[i] = "";
      MemoName[i] = FolderMemos+fileList[i].getName();
      for (int j = 0; j < a.length; j++) MemoMain[i] = MemoMain[i] + a[j] + "\n";
    }
    Img000 = ImgBackground.get(0, 0, 480, 146);
    MemoScroll = 0;
    pPosY = 0;
    MemoNext = -1;
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackground, 0, 0);

  //スクロール
  if (mouseKey != 8) DelMemo = -1;
  if (mouseKey == 8 && abs(mouseY - pmouseY) > 5) mouseKey = 3;
  if (mouseKey == 1 && abs(mouseY - pmouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) MemoScroll = MemoScroll + (mouseY - pmouseY);
  if (MemoScroll < 320-pPosY) MemoScroll = 320-pPosY;
  if (MemoScroll > 0) MemoScroll = 0;

  //リスト
  if (mouseKey == 3) MemoNext = -1;
  if (mouseKey == 0 && MemoNext != -1) {
    BeforeFlgMemo = MasterFlg;
    MasterFlg = 11;
    pMemoName = MemoName[MemoNext];
    //キーボードの初期値
    KeyBodeUnsettled = "";
    KeyBodeDraw = MemoMain[MemoNext];
    NowLine = MemoMain[MemoNext].length();
  }
  int PosY = 146 + MemoScroll;
  textSet(Font001, 24, LEFT, BOTTOM);
  for (int i = 0; i < MemoMain.length; i++) {
    if (MemoF[i] == 0) {
      if (DelMemo == i) MemoX[i] = MemoX[i] + (mouseX - pmouseX);
      else if (MemoX[i] > 8) MemoX[i] = MemoX[i] - 8;
      else if (MemoX[i] < -8) MemoX[i] = MemoX[i] + 8;
      else MemoX[i] = 0;
      translate(MemoX[i], 0);
      if (mouseX > 1 && mouseX < 478 && mouseY > PosY+1 && mouseY < PosY+63 && mouseY > 146) {
        frect(1, PosY+1, 479, 62, BarColor, FillAlphaSub);
        if (MemoNext == i) {
          DelMemo = i;
          mouseKey = 8;
        }
        if (mouseKey == 1) MemoNext = i;
      } else frect(1, PosY+1, 479, 62, BarColor, FillAlpha);
      if (MemoMain[i].replaceAll("\n", " ").length() <= 18) ftextb(MemoMain[i].replaceAll("\n", " "), 20, PosY+50, TextColor[1], TextColor[0]);
      else ftextb(MemoMain[i].replaceAll("\n", " ").substring(0, 17)+"...", 20, PosY+50, TextColor[1], TextColor[0]);
      PosY = PosY + 64;
      translate(-MemoX[i], 0);
      if (abs(MemoX[i]) > 400) {//削除
        MemoF[i] = 1;
        MemoY[i] = 64;
        File f = new File(dataPath("../"+MemoName[i]));
        f.delete();
      } else if (abs(MemoX[i]) > 80 && mouseKey == 8 && MemoNext == i) MemoNext = -1;
    } else {
      if (MemoY[i] > 0) MemoY[i] = MemoY[i] - int(8*frameRateSpeed);
      else MemoY[i] = 0;
      PosY = PosY + MemoY[i];
    }
  }
  pPosY = PosY - MemoScroll - 146;

  //上部タブ
  image(Img000, 0, 0);
  frect(2, 2, 476, 70, SubColor, FillAlphaSub);

  //新規作成
  MakeNewButton(84, 201, 0);

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