//パスワードの変更
int ChangeKeyFlg = 0;
String ChangeKeyNew = "";
String ChangeKeyInput = "";
String[] ChangeKeyMsg = {"現在のパスワードを入力してください。", "新しいパスワードを入力してください。", "もう一度新しいパスワードを入力してください。", "パスワードが違います。", "パスワードが違います。"};

void ChangeKey() {
  //初期化
  if (SubCount == 0) {
    ChangeKeyFlg = 0;
    ChangeKeyInput = "";
  }

  //背景
  background(#000000);
  tint(FillAlpha);
  image(ImgBackgroundSub2[4], 0, 0);

  //震える処理
  PassTime = (PassTime > 0) ? PassTime - 1 : 0;
  translate((PassTime*2)*sin(radians(PassTime*40)), 0);

  //表示
  textSet(Font002, 48, CENTER, CENTER);
  for (int i = 0; i < 4; i++) frect(i*50+145, 120, 40, 4, #FFFFFF, 255);
  for (int i = 0; i < ChangeKeyInput.length(); i++) ftextb("＊", i*50+145+20, 98, TextColor[1], TextColor[0]);
  textSet(Font002, 16, CENTER, CENTER);
  ftextb(ChangeKeyMsg[ChangeKeyFlg], 240, 600, TextColor[1], TextColor[0]);

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
        ChangeKeyInput = ChangeKeyInput + n;
      }
    } else {
      stroke(210, 148);
      ftextb(str(n), x, y, TextColor[2], TextColor[0]);
    }
    fill(0, 0);
    ellipse(x, y, 64, 64);
    noStroke();
  }

  //震え多分戻す
  translate(-(PassTime*2)*sin(radians(PassTime*40)), 0);

  //入力完了
  if (ChangeKeyInput.length() >= 4) {
    switch(ChangeKeyFlg) {
    case 0://1回目現在のパスワード
    case 3:
      if (keyFG(Fkey, ChangeKeyInput)) ChangeKeyFlg = 1;
      else {
        ChangeKeyFlg = 3;      
        PassTime = 30;
      }
      break;
    case 1://新しいパスワード
      ChangeKeyNew = ChangeKeyInput;
      ChangeKeyFlg = 2;
      break;
    case 2://確認
    case 4:
      if (ChangeKeyNew.equals(ChangeKeyInput)) {
        //保存処理＆移動
        keyFG(Fkey, ChangeKeyInput);
        String[] a = {Returnkey};
        saveStrings(FileUserKey, a);
        Fkey = Returnkey;
        PassWordInput = ChangeKeyInput;
        MasterFlg = 5;
      } else {
        ChangeKeyFlg = 4;      
        PassTime = 30;
      }
      break;
    }
    ChangeKeyInput = "";
  }

  //キャンセルボタン
  if (SingleButton("キャンセル", 0)) MasterFlg = 5;
}