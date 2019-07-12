//色の選択
int nextSettingColor = -1;
int ScrollSettingColor = 0;
void SettingColor() {
  //初期化
  if (SubCount == 0) {
    mouseKey = 0;
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
    DelLine(FileInitialize, "main-color");
    DelLine(FileInitialize, "sub-color");
    DelLine(FileInitialize, "bar-color");
    DelLine(FileInitialize, "bar-color-sub");
    DelLine(FileInitialize, "text-color1");
    DelLine(FileInitialize, "text-color2");
    DelLine(FileInitialize, "text-color3");
    DelLine(FileInitialize, "alpha");
    DelLine(FileInitialize, "alpha-sub");

    //行の追加
    AddLine(FileInitialize, "main-color,"+hex(ThemeColor[nextSettingColor][0]));
    AddLine(FileInitialize, "sub-color,"+hex(ThemeColor[nextSettingColor][1]));
    AddLine(FileInitialize, "bar-color,"+hex(ThemeColor[nextSettingColor][2]));
    AddLine(FileInitialize, "bar-color-sub,"+hex(ThemeColor[nextSettingColor][3]));
    AddLine(FileInitialize, "text-color1,"+hex(ThemeColor[nextSettingColor][4]));
    AddLine(FileInitialize, "text-color2,"+hex(ThemeColor[nextSettingColor][5]));
    AddLine(FileInitialize, "text-color3,"+hex(ThemeColor[nextSettingColor][6]));
    AddLine(FileInitialize, "alpha,"+ThemeColor[nextSettingColor][7]);
    AddLine(FileInitialize, "alpha-sub,"+ThemeColor[nextSettingColor][8]);       

    //リロード
    LoadInitialize(FileInitialize);

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
  if (SingleButton("キャンセル", 0)) MasterFlg = 5;
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