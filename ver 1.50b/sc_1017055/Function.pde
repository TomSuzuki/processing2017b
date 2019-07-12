
//クリック
void mousePressed() {
  if (mouseButton == LEFT) mouseKey = 1;
}

//離す
void mouseReleased() {
  if (mouseButton == LEFT) mouseKey = 0;
}

//配列から参照する
//関数名lookupが正しいと思うけど...
//面倒だしこのままでいか？←おい
String vlookup(String p1, String[] p2, String[] p3) {
  String c = "000000000";
  for (int i = 0; i < p2.length; i = i + 1) if (p2[i].equals(p1)) return p3[i];//せんけーたんさく
  return c;
}

//配列の何番目に入っているものと一致するか検索
int alookup(String[] p1,String p2) {
  int n = -1;
  for(int i = 0;i < p1.length;i++) if(p1[i].equals(p2)) return i;//せんけーたんさく
  return n;
}

//指定行を削除
void DelLine(String File, String p1) {//上手く動いてない？←気のせいだったっぽい
  String[] a = loadStrings(File);
  String[] b = new String[a.length];
  int j = 0;
  for (int i = 0; i < a.length; i++) {
    String[] Temp = split(a[i], ",");
    if (Temp[0].equals(p1) == false) {//消さないデータ
      b[j] = a[i]; 
      j = j + 1;
    }
  }
  //必要な分だけ保存（もっといいやりかたないのかな？）
  String[] c = new String[j];
  for (int i = 0; i < c.length; i++) c[i] = b[i];
  saveStrings(File, c);
}

//一致行を削除
void DelLine2(String File, String p1) {//上手く動いてない？←気のせいだったっぽい？
  String[] a = loadStrings(File);
  String[] b = new String[a.length];
  int j = 0;
  for (int i = 0; i < a.length; i++) {
    if (a[i].equals(p1) == false) {//消さないでーた
      b[j] = a[i]; 
      j = j + 1;
    }
  }
  //必要な分だけ保存（もっといいやりかた(ry
  String[] c = new String[j];
  for (int i = 0; i < c.length; i++) c[i] = b[i];
  saveStrings(File, c);
}

//行の追加
void AddLine(String File, String p1) {
  String[] a = loadStrings(File);
  String[] b = new String[a.length+1];
  for (int i = 0; i < a.length; i++) b[i] = a[i];//もっと簡単(ry
  b[a.length] = p1;//最後に追加で↓
  saveStrings(File, b);//ほ☆ぞ☆ん！
}

//距離を求める
//ボタンの処理の簡易化に
//割と使ってる
//範囲指定ミスると
//判定範囲被るから注意！
float kyori(float p1, float p2, float p3, float p4) {
  return sqrt((p3-p1)*(p3-p1) + (p4-p2)*(p4-p2));
}

//日付から曜日を求める
//http://www.h2.dion.ne.jp/~p_soul/jchieyoubi.htm
//ここを参考に作りました。（27世紀でずれるらしいけどそんな先に入力することは想定していないので←おい）
int dayweek(int p1, int p2, int p3) {
  int n;
  if (p2 < 3) {
    p1 = p1 - 1;
    p2 = p2 + 13;
  } else {
    p2 = p2 + 1;
  }
  n = 1+int(365.25*p1)+int(30.6*p2)+int(p1/400)+p3-int(p1/100)-429;
  return n-int(n/7)*7;
}

//テキスト関連をまとめて設定
void textSet(PFont p1, int p2, int p3, int p4) {
  textAlign(p3, p4);
  textFont(p1, p2);
}

//rect+fill
void frect(float p1, float p2, float p3, float p4, int p5, int p6) {
  fill(p5, p6);
  rect(p1, p2, p3, p4);
}

//line+fill
void fline(float p1, float p2, float p3, float p4, int p5, int p6) {
  stroke(p5, p6);
  line(p1, p2, p3, p4);
}

//text+fill
void ftext(String p1, int p2, int p3, int p4) {
  fill(p4);
  text(p1, p2, p3);
}

//text+fill+bordering
void ftextb(String p1, float p2, float p3, int p4, int p5) {
  fill(p5);
  for (int i = 0; i < 9; i++) text(p1, p2-1+i%3, p3-1+i/3);//真ん中被るから意味ないけど面倒だからこのまま←おい
  fill(p4);
  text(p1, p2, p3);
}

//drawPi+fill
void fdrawPi(float x, float y, float r, float par1, float par2, int cc, int a) {
  fill(cc, a);
  arc(x, y, r, r, radians(360*par1-90), radians(360*par2-90));
}

//ellipse+fill
void fellipse(float p1, float p2, float p3, float p4, int p5, int p6) {
  fill(p5, p6);
  ellipse(p1, p2, p3, p4);
}

//月の日数を調べる
//うるうどしめんどう
//これであってんのかなぁ
int getDays(int y, int m) {
  switch(m) {
  case 2:
    if (y%400 == 0) return 29;
    if (y%100 == 0) return 28;
    if (y%4 == 0) return 29;
    return 28;
  case 4:
  case 6:
  case 9:
  case 11:
    return 30;
  }
  return 31;
}

//日付を比べる
boolean chDate(String p1, String p2) {
  String[] d1 = split(p1, "/");
  String[] d2 = split(p2, "/");
  if (int(d1[0]) > int(d2[0])) return true;
  if (int(d1[0]) < int(d2[0])) return false;
  if (int(d1[1]) > int(d2[1])) return true;
  if (int(d1[1]) < int(d2[1])) return false;
  if (int(d1[2]) > int(d2[2])) return true;
  return false;
}

//時間を比べる
boolean chTime(String p1, String p2) {  
  String[] d1 = split(p1, ":");
  String[] d2 = split(p2, ":");
  if (int(d1[0]) > int(d2[0])) return true;
  if (int(d1[0]) < int(d2[0])) return false;
  if (int(d1[1]) > int(d2[1])) return true;
  return false;
}

//イージング関数
//easeing(現在の値 ,経過時間の最大（0から） ,出力最低値 ,出力最大値 ,タイプ)
//0：一定
//1：減速-Quadratic
//2：加速-Quadratic
//3：加速→減速-Quadratic
//100：一定（Loop）
//101：減速-Quadratic（Loop）
//102：加速-Quadratic（Loop）
//103：加速→減速-Quadratic（Loop）
//-------------------------------------
//t：(p1/p2)    進行度
//b：p3         開始の値
//c：(p4-p3)    開始と終了の差分
//d：
float easing(float p1, float p2, float p3, float p4, int p5) {
  float n = 0.0;
  if (p5 >= 100) p1 = p2-abs(p2-p1%(p2*2));  //ループのとき
  p5 = p5%100;
  //例外処理（間違った値を入れた時にフリーズしないように...）
  if (p2 < 0) p2 = 0;
  if (p1 > p2) p1 = p2;
  //メインの処理
  switch(p5) {
  case 0://一定
    if (p2 != 0) n = (p4-p3)*(p1/p2)+p3;
    break;
  case 1://ease:in-Quadratic
    if (p2 != 0) n =(p4-p3)*(p1/p2)*(p1/p2)+p3;
    break;
  case 2://ease:out-Quadratic
    if (p2 != 0) n = -(p4-p3)*(p1/p2)*((p1/p2)-2.0) + p3;
    break;
  case 3://ease:in_out-Quadratic
    p1 = (p1/p2)/0.5;
    if (p2 != 0) {
      if (p1 < 1) {
        n = (p4-p3)/2.0*p1*p1+p3;
      } else {
        p1 = p1 - 1;
        n = -(p4-p3)/2.0*(p1*(p1-2)-1)+p3;
      }
    }
    break;
  }
  return n;
}