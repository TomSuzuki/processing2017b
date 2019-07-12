//ログイン画面
String PassWordInput = "";
int PassFlg = 0;
String Fkey = "";
String[] MasterLoadin = {"パスワードを入力してください。", "パスワードが違います。"};
int PassTime = 0;

//パスワード画面
void MasterLoadin() {
  //初期化
  StratTime = 0;
  if (SubCount == 0) {
    PassWordInput = "";
    PassFlg = 0;
    keyFG("", "0000");
    MakeFileNoFile(FileUserKey, Returnkey);
    String[] temp = loadStrings(FileUserKey);
    if (temp.length > 0) Fkey = temp[0];
    PassTime = 0;
  }

  //背景
  background(#000000);
  tint(FillAlpha);
  image(ImgBackgroundSub2[4], 0, 0);

  //震える処理
  PassTime = (PassTime > 0) ? PassTime - int(1*frameRateSpeed) : 0;
  translate((PassTime*2)*sin(radians(PassTime*40)), 0);

  //表示
  textSet(Font002, 48, CENTER, CENTER);
  for (int i = 0; i < 4; i++) frect(i*50+145, 120, 40, 4, #FFFFFF, 255);
  for (int i = 0; i < PassWordInput.length(); i++) ftextb("＊", i*50+145+20, 98, TextColor[1], TextColor[0]);
  textSet(Font002, 16, CENTER, CENTER);
  ftextb(MasterLoadin[PassFlg], 240, 600, TextColor[1], TextColor[0]);

  //ボタン
  textSet(Font002, 32, CENTER, CENTER);
  for (int i = 0; i < 10; i++) {
    int x = (i%3)*86+240-86;
    int y = (i/3)*86+220;
    int n = i+1;
    if (i == 9) {
      x = 240;
      n = 0;
    }
    strokeWeight(3);
    if (dist(mouseX, mouseY, x, y) < 32) {    
      stroke(240, 240);
      ftextb(str(n), x, y, TextColor[1], TextColor[0]);
      if (mouseKey == 1) {
        mouseKey = 2;
        PassWordInput = PassWordInput + n;
      }
    } else {
      stroke(210, 148);
      ftextb(str(n), x, y, TextColor[2], TextColor[0]);
    }
    fill(0, 0);
    ellipse(x, y, 64, 64);
    noStroke();
  }

  //入力完了（ものすごく雑な暗号化処理）
  if (PassWordInput.length() >= 4) {
    if (keyFG(Fkey, PassWordInput)) PassFlg = 2;
    else {
      PassFlg = 1;
      PassWordInput = "";
      PassTime = 30;
    }
    //println(Gkey);
  }

  //別ページへ
  if (PassFlg == 2) MasterFlg = 0;

  //震え多分戻す
  translate(-(PassTime*2)*sin(radians(PassTime*40)), 0);
}