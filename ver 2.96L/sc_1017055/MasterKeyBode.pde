//キーボード初期化
String KeyBodeCode = "", KeyBodeDraw = "", KeyBodeOut = "", KeyBodeCode2 = "", KeyBodeCode3 = "";
int KeyShift = 0;
int KeyType = 1;
String[] KeyBodeText;
int[] KeyBodeX;
int[] KeyBodeY;
int[] KeyBodeWidth;
int[] KeyBodeHeight;
String[] LoadFile;
int NowLine;
String KeyBodeUnsettled = "", KeyBodeDrawF = "";
int mx, my;
String KeyBodeUpDate = "";
int PtPos = 0;
int CtrVTime = -1;

//しょーきかしょきか
void ResetKeybode() {
  //キーボードのロード（初期化含む）
  MakeFileNoFile(FileDataKeybode, default_FileDataKeybode);
  LoadFile = loadStrings(FileDataKeybode);//データはこれに入っているぞ
  KeyBodeText = new String[LoadFile.length];//なかみ
  KeyBodeX = new int[LoadFile.length];//ざひょー
  KeyBodeY = new int[LoadFile.length];//ざひょー
  KeyBodeWidth = new int[LoadFile.length];//はば
  KeyBodeHeight = new int[LoadFile.length];//たかさ
  for (int i = 0; i < LoadFile.length; i++) {
    String Temp[] = split(LoadFile[i], ",");
    KeyBodeText[i] = Temp[0];
    KeyBodeX[i] = int(Temp[1]);
    KeyBodeY[i] = int(Temp[2]);
    KeyBodeWidth[i] = int(Temp[3]);
    KeyBodeHeight[i] = int(Temp[4]);
  }
  NowLine = 0;
  CtrVTime = -1;
}

//キーボードの処理（BeforeFlgMemoに戻る）
//MasterFlg = 10
void MasterKeyBode() {
  //処理
  mx = mouseX;
  my = mouseY;
  KeyBodeDrawF = KeyBodeDraw.substring(0, NowLine) + KeyBodeUnsettled + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
  if (NowLine < 0) NowLine = 0;
  if (NowLine > KeyBodeDrawF.length()) NowLine = KeyBodeDrawF.length();

  //背景
  background(#000000);
  tint(FillAlpha);
  image(ImgBackground, 0, 0);

  //キャンセル||完了
  switch(CompleteButton(true)) {
  case 1://キャンセル
    MasterFlg = BeforeFlgMemo;
    break;
  case 2://完了
    KeyBodeUpDate = "_"+KeyBodeDrawF;
    MasterFlg = BeforeFlgMemo;
    break;
  }

  //文字
  textSet(Font001, 18, LEFT, TOP);
  ftextb2(KeyBodeDrawF, 20, 82, TextColor[0], TextColor[2], 440, 640);
  ftextb2(KeyBodeDrawF.substring(0, NowLine), 20, 82, TextColor[1], TextColor[0], 440, 640);

  //描画
  textAlign(CENTER, CENTER);
  textFont(Font001, 18);
  fill(BarColor);
  rect(0, height-280, width, 40);
  if (dist(mouseX, mouseY, 450, height-260) < 12) {
    ftextb("＋", 450, height-260, TextColor[1], TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      PtPos = PtPos + 1;
    }
  } else ftextb("＋", 450, height-260, TextColor[2], TextColor[0]);
  if (dist(mouseX, mouseY, 30, height-260) < 12) {
    ftextb("ー", 30, height-260, TextColor[1], TextColor[0]);
    if (mouseKey == 1) {
      mouseKey = 2;
      PtPos = PtPos - 1;
    }
  } else ftextb("ー", 30, height-260, TextColor[2], TextColor[0]);
  fill(MainColor);
  rect(0, height-240, width, 240);

  //変換前の文字列
  String KeyBodeUnsettledStart = KeyBodeDrawF;

  //クリップボード
  CtrVTime = CtrVTime - 1;
  if (mouseKey == 1 && mouseY < 360 && CtrVTime < 0) {
    CtrVTime = 30;
    mouseKey = 2;
  }
  if (mouseKey == 1 && mouseY < 360 && CtrVTime > 0) {
    CtrVTime = -1;
    mouseKey = 2;
    if (getClipboardString() != null) {
      KeyBodeDraw = KeyBodeDraw.substring(0, NowLine) + getClipboardString() + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
      NowLine = NowLine + getClipboardString().length();
    }
  }

  //入力
  for (int i = 0; i < KeyBodeText.length; i++) {
    if (KeyBodeText[i] != "" && KeyBodeText[i] != null) {
      fill(BarColorSub);
      if (mx > KeyBodeX[i] && mx < KeyBodeX[i]+KeyBodeWidth[i] && my > KeyBodeY[i]+height-60*4 && my < KeyBodeY[i]+height-60*4+KeyBodeHeight[i]) {
        fill(BarColor);
        if (mouseKey == 1) {
          mouseKey = 2;
          switch(KeyBodeText[i]) {
          case "Shift":
            KeyShift = KeyShift + 1;
            if (KeyShift > 1) KeyShift = 0;
            break;
          case "全":
            KeyType = 0;
            KeyBodeText[i] = "半";
            KeyBodeDraw = KeyBodeDraw.substring(0, NowLine) + KeyBodeUnsettled + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
            NowLine = NowLine + KeyBodeUnsettled.length();
            KeyBodeUnsettled = "";
            break;
          case "半":
            KeyType = 1;
            KeyBodeText[i] = "全";
            KeyBodeDraw = KeyBodeDraw.substring(0, NowLine) + KeyBodeUnsettled + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
            NowLine = NowLine + KeyBodeUnsettled.length();
            KeyBodeUnsettled = "";
            break;
          case ">":
            NowLine = NowLine + 1;
            if (NowLine > KeyBodeDraw.length()) NowLine = KeyBodeDraw.length();
            break;
          case "<":
            NowLine = NowLine - 1;
            if (NowLine < 0) NowLine = 0;
            break;
          case "<<":
            break;
          case "SP":
            KeyBodeCode = KeyBodeCode + KeyType + "* ;";
            break;
          case "Ent":
            if (KeyBodeUnsettled.equals("")) {
              KeyBodeDraw = KeyBodeDraw.substring(0, NowLine) + "\n" + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
              NowLine = NowLine + 1;
            } else {
              KeyBodeDraw = KeyBodeDraw.substring(0, NowLine) + KeyBodeUnsettled + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
              NowLine = NowLine + KeyBodeUnsettled.length();
              KeyBodeUnsettled = "";
            }
            break;
          case "del":
            if (KeyBodeUnsettled.length() > 0) {
              KeyBodeUnsettled = KeyBodeUnsettled.substring(0, KeyBodeUnsettled.length()-1);
            } else {
              if (NowLine <= KeyBodeDraw.length() && KeyBodeDraw.equals("") == false) KeyBodeDraw = KeyBodeDraw.substring(0, NowLine-1) + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
              if (NowLine > KeyBodeDraw.length()) NowLine = KeyBodeDraw.length();
            }
            break;
          default://とりあえず全角だけ考える
            KeyBodeCode = KeyBodeCode + KeyShift + "*" + KeyBodeText[i] + ";";
            break;
          }
        }
      }
      if (KeyBodeText[i].equals("Shift")) if (KeyShift == 1) fill(120); 
      rect(KeyBodeX[i], KeyBodeY[i]+height-60*4, KeyBodeWidth[i], KeyBodeHeight[i]);
      fill(BarColorSub);
      if (KeyShift == 0) {
        ftextb(KeyBodeText[i], KeyBodeX[i]+KeyBodeWidth[i]/2, KeyBodeY[i]+height-60*4+KeyBodeHeight[i]/2, TextColor[1], TextColor[0]);
      } else {
        ftextb(UppercaseLetter(KeyBodeText[i]), KeyBodeX[i]+KeyBodeWidth[i]/2, KeyBodeY[i]+height-60*4+KeyBodeHeight[i]/2, TextColor[1], TextColor[0]);
      }
    }
  }

  //入力から文字列に置き換え
  String[] CodeTemp = split(KeyBodeCode, ";");
  for (int i = 0; i < CodeTemp.length; i++) {
    String[] a = split(CodeTemp[i], "*");
    if (a.length > 1) { 
      if (a[0].equals("1")) a[1] = UppercaseLetter(a[1]);
      KeyBodeUnsettled = KeyBodeUnsettled + a[1];
    }
  }
  KeyBodeCode = "";

  //ローマ字変換（全角モードのときのみ実行？）
  if (KeyType == 1) {
    int TextPos = 0;
    int TextLength = 1;
    String a = "";
    while (TextPos < KeyBodeUnsettled.length()) {
      String ForRome = KeyBodeUnsettled.substring(TextPos, TextPos+TextLength);//変換対象
      String AfterConversion = ConvertToRomaji(ForRome);
      if (AfterConversion.equals(ForRome)) {//変換がなかった
        if (TextLength > 6 || TextPos+TextLength == KeyBodeUnsettled.length()) {  //これ以上変換にかけても見つかる見込みがない
          a = a + KeyBodeUnsettled.substring(TextPos, TextPos+1);
          TextPos = TextPos + 1;
          TextLength = 1;
        } else {  //まだ可能性がある
          TextLength = TextLength + 1;
        }
      } else {//変換があった
        a = a + AfterConversion;
        TextPos = TextPos + ForRome.length();
        TextLength = 1;
      }
    }
    KeyBodeUnsettled = a;
  } else {
  }

  //描画に送るものを変換用に
  KeyBodeDrawF = KeyBodeDraw.substring(0, NowLine) + KeyBodeUnsettled + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());

  //候補
  if (KeyBodeUnsettledStart.equals(KeyBodeDrawF) == false) {
    KeyBodeOut = PredictiveTransformation(KeyBodeUnsettled);
    PtPos = 0;
  }
  if (KeyBodeDrawF.equals("")) KeyBodeOut = "";
  String[] CandidateList = split(KeyBodeOut, ";");
  textAlign(LEFT, CENTER);
  int x = 60;
  KeyBodeCode3 = "";
  if (PtPos < 0) PtPos = 0;
  if (PtPos > CandidateList.length-1) PtPos = CandidateList.length-1;
  for (int i = 0; i < CandidateList.length; i++) {
    if (PtPos+i < CandidateList.length) {
      String[] Candidate = split(CandidateList[PtPos+i], ",");
      if (Candidate.length > 1) {
        if (x + textWidth(Candidate[1]) < 430) {
          fill(#111111);
          if (mouseY > 360 && mouseY < 400 && mx > x && mx < x+textWidth(Candidate[1]) && mouseX < 440) {
            fill(#555555);
            if (mouseKey == 1) {//選択した
              mouseKey = 2;
              KeyBodeUnsettled = KeyBodeUnsettled.substring(int(Candidate[2]), KeyBodeUnsettled.length());
              KeyBodeDraw = KeyBodeDraw.substring(0, NowLine) + Candidate[1] + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
              NowLine = NowLine + Candidate[1].length();
              KeyBodeOut = PredictiveTransformation(KeyBodeUnsettled);
            }
          }
          text(Candidate[1], x, height-260);
        }
        x = x + int(textWidth(Candidate[1])) + 20;
      }
    }
  }

  //描画に送る
  KeyBodeDrawF = KeyBodeDraw.substring(0, NowLine) + KeyBodeUnsettled + KeyBodeDraw.substring(NowLine, KeyBodeDraw.length());
}

//ローマ字変換
String[][] ConvertToRomajiData;
void LoadConvertToRomaji(){
  MakeFileNoFile(FileDataRomeji, default_FileDataRomeji);
  String[] a = loadStrings(FileDataRomeji);
  ConvertToRomajiData = new String[a.length][2];
  for(int i = 0;i < a.length;i++){
    String[] b = split(a[i], ",");
    if (b.length > 1){
      ConvertToRomajiData[i][0] = b[0];
      ConvertToRomajiData[i][1] = b[1];
    }
  }
}

String ConvertToRomaji(String p1) {
  for (int i = 0;i < ConvertToRomajiData.length;i++) if (p1.equals(ConvertToRomajiData[i][0])) return ConvertToRomajiData[i][1];
  return p1;
}

//シフト文字
String[][] UppercaseLetterData;
void LoadUppercaseLetter(){
  MakeFileNoFile(FileDataShift, default_FileDataShift);
  String[] a = loadStrings(FileDataShift);
  UppercaseLetterData = new String[a.length][2];
  for(int i = 0;i < a.length;i++){
    String[] b = split(a[i], ",");
    if (b.length > 1){
      UppercaseLetterData[i][0] = b[0];
      UppercaseLetterData[i][1] = b[1];
    }
  }
}

String UppercaseLetter(String p1) {
  for (int i = 0;i < UppercaseLetterData.length;i++) if (p1.equals(UppercaseLetterData[i][0])) return UppercaseLetterData[i][1];
  return p1;
}
