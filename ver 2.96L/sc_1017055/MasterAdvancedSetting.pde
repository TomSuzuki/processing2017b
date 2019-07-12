//詳細設定
boolean OptionTileImage = false;
boolean OptionVariablefps = false;
String[] OptionItem = {"タイルの画像化","動作の最適化（ベータ版）",""};
String[] OptionMsg = {"メイン画面のタイルを画像にします（設定しないでください）","動作速度を環境に合わせて変化させます（非推奨）",""};
String[] OptionDat = {"option-tileimage","option-variablefps"};
boolean[] OptionItemBoolean = new boolean[OptionItem.length];
int NextOption = -1;
int MasterOptionScroll = 0, MasterOptionScrollMax = 0;

//設定画面
void MasterAdvancedSetting(){
//初期化
    if (SubCount == 0){
        LoadAdvancedSetting();
        MasterOptionScroll = 0;
        MasterOptionScrollMax = 0;
        NextOption = -1;
        OptionItemBoolean[0] = OptionTileImage;
        OptionItemBoolean[1] = OptionVariablefps;
    }

    //背景
    background(#000000);
    tint(FillAlphaSub);
    image(ImgBackground, 0, 0);

    //スクロール
    if (mouseKey == 1 && abs(pmouseY - mouseY) > 1) mouseKey = 3;
    if (mouseKey == 3) MasterOptionScroll = MasterOptionScroll + (pmouseY - mouseY);
    if (MasterOptionScrollMax - 180 < MasterOptionScroll) MasterOptionScroll = MasterOptionScrollMax - 180;
    if (MasterOptionScroll < 0) MasterOptionScroll = 0;
    int PosY = 72;

    //処理
    if (mouseKey == 3) NextOption = -1;
    if (mouseKey == 0 && NextOption != -1){
        OptionItemBoolean[NextOption] = toggleboolean(OptionItemBoolean[NextOption]);
        NextOption = -1;
    }
    
    //描画
    for(int i = 0;i < OptionItem.length;i++){
        if (OptionItem[i].equals("") == false) OptionDrawBar(PosY,i,OptionItemBoolean[i]);
        PosY = PosY + 72;
    }

    //戻る
    frect(0, 0, 480, 64, MainColor, 255);
    if (SingleButton("戻る", 0)) {
        for (int i = 0;i < OptionDat.length;i++) DelLine(FileInitialize, OptionDat[i]);
        for (int i = 0;i < OptionDat.length;i++) AddLine(FileInitialize, OptionDat[i]+","+stringboolean(OptionItemBoolean[i]));
        LoadAdvancedSetting();
        MasterFlg = 5;
    }
}

//詳細設定のロード
void LoadAdvancedSetting(){
    String[] FileLoad = loadStrings(FileInitialize);
    for (int i = 0; i < FileLoad.length; i = i + 1) {
        String[] Temp2 = split(FileLoad[i], ";");
        String[] Temp = split(Temp2[0], ",");
        if (Temp[0].equals("option-tileimage")) OptionTileImage = getboolean(Temp[1]);
        else if (Temp[0].equals("option-variablefps")) OptionVariablefps = getboolean(Temp[1]);
    }
}

//詳細の項目
void OptionDrawBar(int y,int i,boolean p) {
    if (blimt(mouseX, 1, 479) && blimt(mouseY, y+1, y+71) && mouseY > 72) {
      frect(1, y+1, width-2, 70, BarColor, FillAlphaSub);
      if (mouseKey == 1) NextOption = i;
    } else frect(1, y+1, width-2, 70, BarColor, FillAlpha);
    textSet(Font001, 24, LEFT, TOP);
    ftextb(OptionItem[i], 20, y+20, TextColor[1], TextColor[0]);
    textSet(Font001, 12, LEFT, BOTTOM);
    ftextb(OptionMsg[i], 30, y+65, TextColor[1], TextColor[0]);
    textSet(Font001, 24, CENTER, CENTER);
    if (p) ftextb("TRUE", 400, y+36, TextColor[1], TextColor[0]);
    else ftextb("FALSE", 400, y+36, TextColor[1], TextColor[0]);
}

//文字列に
String stringboolean(boolean p){
    if (p) return "true";
    return "false";
}

//trueならfalseを返す
boolean toggleboolean(boolean p){
    if (p) return false;
    return true;
}

//文字列をbooleanに
boolean getboolean(String p1){
    if (p1.equals("false")) return false;
    if (p1.equals("False")) return false;
    if (p1.equals("FALSE")) return false;
    if (p1.equals("0")) return false;
    return true;
}