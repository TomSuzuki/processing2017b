String NewSubjectName = "";
int ColorX = 0, ColorY = 0;
color ColorNow;
//新しい科目の追加
void MasterNewSubject() {  
  //初期化
  if (SubCount == 0) {
    //キーボードから戻ってきた
    if (KeyBodeUpDate.equals("") == false) {
      NewSubjectName = KeyBodeUpDate.substring(1, KeyBodeUpDate.length()).replaceAll("\n", " ");
      KeyBodeUpDate = "";
    } else {
      NewSubjectName = "";
      ColorNow = color(0, 0, 0);
    }
  }

  //背景
  background(#000000);
  tint(FillAlphaSub);
  image(ImgBackgroundSub, 0, 0);

  //科目名
  if (mouseX > 1 && mouseX < 479 && mouseY > 129 && mouseY < 199) {
    frect(1, 129, 478, 70, MainColor, FillAlpha);
    if (mouseKey == 1) {
      mouseKey = 2;
      BeforeFlgMemo = MasterFlg;
      MasterFlg = 11;
      //キーボードの初期値
      KeyBodeUnsettled = "";
      KeyBodeDraw = NewSubjectName;
      NowLine = NewSubjectName.length();
    }
  }
  frect(1, 129, 478, 70, #EEEEEE, FillAlpha);
  frect(1, 129, 18, 70, ColorNow, FillAlpha);  
  textSet(Font001, 24, LEFT, TOP);
  ftextb(NewSubjectName, 40, 128+15, TextColor[1], TextColor[0]);  

  //色
  if (mouseKey == 1 && mouseX > 80 && mouseX < 400 && mouseY > 260 && mouseY < 580) mouseKey = 5;
  if (mouseKey == 5) {
    ColorX = mouseX;
    ColorY = mouseY;
  }
  if (ColorX < 80) ColorX = 80;
  if (ColorX > 400) ColorX = 400;
  if (ColorY < 260) ColorY = 260;
  if (ColorY > 580) ColorY = 580;
  ColorNow = Img001.get(ColorX-80, ColorY-260);
  frect(76, 256, 328, 328, #FFFFFF, 255);
  image(Img001, 80, 260);
  fellipse(ColorX, ColorY, 10, 10, 255, 255);
  fill(red(ColorNow), green(ColorNow), blue(ColorNow));
  ellipse(ColorX, ColorY, 8, 8);

  //キャンセル||完了
  switch(CompleteButton(NewSubjectName.equals("")==false)) {
  case 1://キャンセル
    MasterFlg = BefireFlgNewSubject;
    break;
  case 2://完了
    AddLine("data/theme/subject.csv", "FF"+hex(int(red(ColorNow)), 2)+hex(int(green(ColorNow)), 2)+hex(int(blue(ColorNow)), 2)+","+NewSubjectName);
    LoadSubjectList("theme/subject.csv");     //科目のロード
    MasterFlg = BefireFlgNewSubject;
    break;
  }
}