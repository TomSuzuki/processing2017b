//1017055
//鈴木利武
//
// VScode：Ctrl + Shift + B
//
//　プログラムはめちゃくちゃです。
//　怒られてもいいと思うくらい雑というか意味のない部分というか非効率というか別のやり方あるとかって感じなので...
//
//　※コメントの所々に日記っぽい何かがありますが気にせずに飛ばしてください。（バグが消えないとコメント書く癖があるっぽい...）
//　カレンダー、ユリウス暦とか旧暦とかその他の暦対応だったら面白かったかなぁ
//　よく言われるけど/**/嫌いなんだよなぁ（デバッグ用にしか使いたくない）
//　/**/使うと確実にコメントの量が増えるってわかりきってるからね。
//
//　＞----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------＜
//　　文字サイズの設定など、処理が明らかなもののコメントは書いていません。（意味ないコメント書くとわけわかんなくなることがブロック崩しでよくわかったので。）
//　　たまにある明らかにふざけたコメントは無視しておｋです。
//　　コメントで会話してるけどきにするな！！
//　＞----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------＜
//
//　　classとかライブラリ使え！　←　一部で使ったはず
//　　使わなくなったら解放しろ
//
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//　◆　記録　◆
//　（'17 07/03）　ブロック崩しでやりすぎた感があったのでこのスケジューラはまともなものを作ります。（目標）
//　（'17 07/05）　漢字変換ってまともかなぁ...（まぁ見た目は普通だよね？）
//　（'17 07/10）　またコメント地獄が...
//　（'17 07/10）　ニコニコ大百科を使って作った辞書がライセンス的に危なそうだったから自分で辞書作った。つかれた。※途中から、音楽聞きながら歌詞を書いただけ。←4時間くらいやってたから指いたい。
//　　　　　　　　　辞書見たらどんな曲聞いてたか多分わかると思う...
//　（'17 07/11）　ねむい（03:38）やっと ver 1.00だ... ←一応使えるってこと
//　（'17 07/13）　最近1日3時間しかねてないからいい処理思いつかない（ただの言い訳）
//　　　　　　　　　行数数えたら300行近く1日で増えたのか...（昨日の時点でほとんど完成してたと思ったのに....）
//　　　　　　　　　10日前に書いた目標を振り返ってみると、まぁ、ブロック崩しよりはまともなものができたかなって感じかな
//　　　　　　　　　ここまで作るのに10日っていうのが少し信じられない（作業時間は100時間超えてると思うど...←発表終わったらすぐに帰って寝たい...）
//　　　　　　　　　100時間って言っても10日以上前に作っていたパーツの部分含むし、紙に案を書いてる時間も含むけど
//　（'17 07/20）　import縛りやめたいというかやめる（Twitter連携）
//　（'17 07/22）　どこがこんなにメモリを食ってるのか...（主にP2Dだけどほかに理由ありそう...）
//　（'17 07/23）　Visual Studio Codeに開発環境を移した（ファイルを増やしたかったけどタブがあれだから...）
//　（'17 07/26）　キャラ描いて、プログラム書いて、テストして...
//　　　　　　　　　作りたいから作ってるだけなんだけどね...
//　（'17 07/27）　発表スライドどうしよう
//
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//　◆　更新　◆
//　ver 2.96   2017/07/27　詳細設定を追加した
//　ver 2.95   2017/07/27　ローマ字、シフト文字をファイルから読み込むように変更
//　ver 2.94   2017/07/27　ファイルの構成とプログラムの修正
//　ver 2.93   2017/07/27　オフライン時に天気を取得しようとしてフリーズするバグの修正
//　ver 2.92   2017/07/26　カレンダーの描画に関する問題の解決
//　ver 2.91   2017/07/26　バグの修正　（4,468行）
//　ver 2.90   2017/07/26　放置していた詳細天気予報が（雑に）完成
//　ver 2.81   2017/07/26　零のUIを改良
//　ver 2.80   2017/07/26　キャラクター（零）を追加
//　ver 2.71   2017/07/25　天気予報の地域を変更できるようにした
//　ver 2.70   2017/07/25　天気予報をつけた
//　ver 2.63   2017/07/25　メモに改行が入った場合のずれを修正
//　ver 2.62   2017/07/24　カレンダーに戻った時に今日の日付に飛ぶバグの修正
//　ver 2.61b  2017/07/24　動作速度の精度向上
//　ver 2.61   2017/07/24　アニメーションの不具合の修正
//　ver 2.60   2017/07/24　動作速度に関する修正
//　ver 2.53d  2017/07/23　最前面表示に関する不具合の修正
//　ver 2.53b  2017/07/23　Visual Studio Codeの使用を開始
//　ver 2.53   2017/07/23　パスワードの改良
//　ver 2.52   2017/07/23　時計型選択画面でのバグの修正と操作性の向上（選択方向にずれあり）
//　ver 2.51   2017/07/23　予測変換に関するバグの修正
//　ver 2.50   2017/07/23　クリップボードからのコピーに対応（ダブルクリック）
//　ver 2.41   2017/07/22　ツイートできなかった時にボタン枠を赤くするようにした
//　ver 2.40   2017/07/22　リンク関連のバグの修正
//　ver 2.34   2017/07/22　機能の修正
//　ver 2.33   2017/07/22　メモリの消費量を減らすテスト版
//　ver 2.32   2017/07/22　プログラムの統合、処理の見直し　（4,067行）
//　ver 2.31   2017/07/22　処理の簡易化、プログラムの整形
//　ver 2.30c  2017/07/22　細かなバグの修正
//　ver 2.30b  2017/07/22　動作を軽くするために設定の読み込み方法を変更
//　ver 2.30   2017/07/22　エラーが多発する上にたぶん使わないのでフォント変更を封じた
//　ver 2.20   2017/07/22　フォント変更可能版
//　ver 2.12b  2017/07/21　最前面表示
//　ver 2.12   2017/07/21　設定画面の大幅更新
//　ver 2.11   2017/07/21　パスワード失敗時にアニメーションをつけた
//　ver 2.10c  2017/07/21　レイアウトの一部修正　（4,351行）
//　ver 2.10b  2017/07/21　起動画面に明日までのイベント件数を表示
//　ver 2.10   2017/07/21　ツイートボタンの追加（ツイッター連携開始）
//　ver 2.00   2017/07/20　（意味のない）パスワードをつけた
//　ver 1.61   2017/07/20　メモの右端折り返し
//　ver 1.60d  2017/07/19　表示の統一　（4,057行）
//　ver 1.60c  2017/07/19　言葉の修正
//　ver 1.60b  2017/07/19　イベントの時間に関するバグの修正
//　ver 1.60   2017/07/19　イベントモードの追加＆バグの修正
//　ver 1.52   2017/07/19　Shift文字の追加
//　ver 1.51   2017/07/18　バグと文字の修正
//　ver 1.50c  2017/07/13　カレンダーの見やすさの修正とテーマカラーの追加
//　ver 1.50b  2017/07/13　バグの修正　（3,583行）
//　ver 1.50   2017/07/13　全部のボタンが動くようになりました。
//　ver 1.41   2017/07/12　テーマカラーの設定関連の処理の見直し
//　ver 1.40   2017/07/12　読み込み処理の見直し
//　ver 1.30   2017/07/12　一部仕様変更
//　ver 1.22   2017/07/12　一部仕様変更
//　ver 1.21   2017/07/12　バグの修正とキーボードの一部仕様変更
//　ver 1.20c  2017/07/12　機能の修正　（3,291行）
//　ver 1.20   2017/07/12　科目をソフトウェア上から追加できるようにした
//　ver 1.10   2017/07/12　メモ機能の追加とバグの修正
//　ver 1.01　 2017/07/11　バグの修正
//　ver 1.00   2017/07/11　メインの機能実装完了（詳細設定、一部機能未完成）
//　beta 3.00  2017/07/03　制作開始（3回目の作り直し）
//
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

String TitleVer = "ver 2.96";

//なんかいろいろ（使わんものもあると思う）
import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;
import java.util.concurrent.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

//動作設定用
float frameRateSpeed = 1;//1=60fps 2=30fps 1~6
int pmillis;

//システム
PFont Font001, Font002;//（フォントデータ）
PImage Img000, Img001, Img002, Img003, ImgBefore, ImgTAB;  //イメージデータ（使ってないものある）
PImage[] ImgBackgroundSub2 = new PImage[5];
int mouseKey = 0;           //マウス
int BeforeFlg = 0;          //前回フラグ
int MasterFlg = -1;         //親フラグ
int pMasterFlg = -1;        //前回Flg
int BeforeFlg2 = -1;        //前回フラグ（２）
int BeforeFlgMemo = -1;     //メモ復帰フラグ
int BefireFlgNewSubject = -1;  //新規科目戻りフラグ
int BeforeFlgSelect = -1;   //セレクト復帰フラグ
int BeforeFlgSubject = -1;  //科目選択復帰フラグ
int BefireFlgNewEvent = -1;
int SubCount = 0;           //フラグが変わってからのカウント
String LinkFileName = "";   //リンクするときに使う
//個々にFlgがあるのは戻るときにロードcaseに一度飛ぶ予定があるから

//テーマ関連（変数名のままなので説明は省略）←場所によって使い方（？）が変わるので色の指定としか言えない
int MainColor = #EE4444;
int SubColor = #EE6666;
int BarColor = #AAAAAA;
int BarColorSub = #EEEEEE;
int[] TextColor = {#000000, #EEEEEE, #111111};
int FillAlpha = 180;
int FillAlphaSub = 200;
PImage ImgBackground, ImgBackgroundSub;
color[] EventColor = {color(255, 255, 255), color(255, 255, 0), color(255, 0, 255), color(0, 255, 255), color(0, 0, 255), color(0, 255, 0)};

//カレンダー
int SelectYear = year();  //選択中の年
int SelectMonth = month();//選択中の月
int SelectDay = day();    //選択中の日
String[] WeekDay = {"SUN", "MON", "TUE", "WED", "THU", "FRI", "SUT"};  //英語の曜日
String[] WeekDay2 = {"日", "月", "火", "水", "木", "金", "土"};        //日本語の曜日

//スケジュールデータ
String[] ScheduleDate;    //YYYY/MM/DD
String[] ScheduleTime;    //hh/mm
String[] ScheduleSubject; //科目名
String[] ScheduleMemo;    //[\n]は[%n]に置き換えてある
float[] SchedulePercent;  //0.0 - 1.0
float[] ScheduleStudyTime;//学習時間

//科目データ
String[] SubjectList;  //科目リスト
String[] SubjectColor; //科目の色

void setup() {
  LoadAdvancedSetting();                    //詳細な設定

  //メイン
  size(480, 640, P2D);//P2Dにしなければメモリの使用量が3分の1くらいに減る
  noSmooth();//P2Dのときは意味ない？
  noStroke();//ノーストローク
  surface.setTitle("課題スケジューラ  "+TitleVer);//タイトル変更（バージョン入り）

  //画像のロード
  Img001 = loadImage("system/sys001.bmp"); //色の表？グラフ？洗濯用。違う、選択用
  Img002 = loadImage("system/sys002.png"); //×ボタン（仮？）←仮データが本データになることの方が多いから多分変えないな
  ImgCharacter[0] = loadImage("character/zero_000.png");
  ImgCharacter[1] = loadImage("character/zero_001.png");
  ImgCharacter[2] = loadImage("character/zero_002.png");
  ImgCharacter[3] = loadImage("character/zero_003.png");

  //初期画面
  LoadInitialize(FileInitialize);               //設定のロード
  MasterStart();//一度描画（なんかおかしいのは気のせい？）
}

void draw() {
  
  //描画リセット
  clear();
  surface.setSize(480, 640);  //画面サイズを強制
  surface.setAlwaysOnTop(true);//最前面（VSCodeにしてから動いてない？）

  //メモリリークの対策
  for (int i = 0;i < ImgBackgroundSub2.length;i++) g.removeCache(ImgBackgroundSub2[i]);
  g.removeCache(Img000);
  g.removeCache(ImgTAB);
  g.removeCache(ImgBackground);
  g.removeCache(ImgBackgroundSub);
  g.removeCache(ImgBefore);
  
  //画面変更時にずらす
  if (SelectTimeR <= 30) translate(easing(SelectTimeR, 30, 480, 0, 103), 0);//画面変更のときにずらすやつ
  //メインの動作
  switch(MasterFlg) {
  case -3://パスワード画面
    MasterLoadin();
    break;
  case -2://起動画面
    MasterStart();
    break;
  case -1://リロード
    LoadSubjectList(FileThemeSubject);        //科目のロード
    LoadInitialize(FileInitialize);           //設定のロード
    LoadSchedule(FileDataSchedule);           //スケジュールのロード
    ResetKeybode();                           //キーボードの初期化
    LoadUppercaseLetter();                    //シフト文字の設定の読み込み
    LoadConvertToRomaji();                    //ローマ字の設定
    LoadEvent();                              //イベントのロード
    LoadTwitterData();                        //ツイッタ関連
    GetWeather();                             //天気の取得
    MasterFlg = -2;
    //初回に時間がかかるっぽいので
    MasterCalendarMain();
    background(#000000);
    MasterStart();
    break;
  case 0://メインメニュー
    MasterSelect();
    break;
  case 1: //カレンダー（メイン）
    MasterCalendarMain();
    break;  
  case 2://カレンダー（サブ）
    MasterCalendarSub();
    break;
  case 5://設定画面
    MasterSetting();
    break;
  case 10://課題設定画面（）
    MasterSettingHomework();
    break;
  case 11://キーボード
    MasterKeyBode();
    break;
  case 12://科目選択画面
    MasterSubject();
    break;
  case 20://年を選択
    MasterSelectYear();
    break;
  case 21://月日を選択
    MasterSelectDate();
    break;
  case 22://時計の設定
    MasterClock();
    break;
  case 30://テーマカラーの選択（初期化）
    SettingColorInitialize();
    SettingColor();
    MasterFlg = 31;
    break;
  case 31://テーマカラーの選択
    SettingColor();
    break;
  case 32://新しい科目の追加
    MasterNewSubject();
    break;
  case 40://学習時間の入力
    MasterInputTime();
    break;
  case 50://パスワードの変更
    ChangeKey();
    break;
  case 100://新規作成ボタン
    MasterSettingHomeworkReset();
    MasterFlg = 10;
    break;
  case 101://修正（修正後に元データは消す？）
    SettingHomeworkFlg = 1;
    MasterFlg = 10;
    break;
  case 120://イベント（リスト表示）
    MasterEvent();
    break;
  case 121://イベント作成
    NweEvent();
    SelectTimeR = 31;
    break;
  case 200://再起動
    MasterFlg = -1;
    SelectTime = 0;
    SartPosY = 0;
    break;
  case 201://メモ機能
    MasterMemo();
    break;
  case 202://終了
    exit();
    break;
  case 300://リンク
    MakeFileNoFile(LinkFileName, "");
    String[] a = loadStrings(LinkFileName);
    link(a[0]);//リンク
    MasterFlg = 0;
    SelectTimeR = 31;
    SelectNext = -1;
    break;
  case 301://ランチャー
    MakeFileNoFile(LinkFileName, "");
    String[] b = loadStrings(LinkFileName);
    try {//リンク実行
      Runtime r = Runtime.getRuntime();
      Process process = r.exec(b);
    } 
    catch (Exception e) {
    }
    MasterFlg = 0;
    SelectTimeR = 31;
    SelectNext = -1;   
    break;
  case 500://記録へ
    CalendarMainNowTab = 3;
    MasterFlg = 1;
    break;
  case 600://セレクトイメージ
    MasterSelectImage();
    break;
  case 601://メイン
    MasterSelectImageFlg = 0;
    MasterFlg = 600;
    break;
  case 602://サブ
    MasterSelectImageFlg = 1;
    MasterFlg = 600;
    break;
  case 700://タイルの設定
    MasterTile();
    break;
  case 701://新規ウェブリンク
    LinkFlg = 0;
    BeforeFlg = 700;
    MasterFlg = 703;
    NewLinkTile();
    break;
  case 702://新規アプリリンク
    LinkFlg = 1;
    BeforeFlg = 700;
    MasterFlg = 703;
    NewLinkTile();
    break;
  case 703://リンクタイルの編集画面
    NewLinkTile();
    break;
  case 705://タイルの削除
    DeleteTile();
    break;
  case 800://天気予報
    MasterWeather();
    break;
  case 801://地域設定
    SelectWeather();
    break;
  case 900://詳細設定
    MasterAdvancedSetting();
    break;
  default://無かったら再起動
    MasterFlg = -1;
    break;
  }

  //切り替え関連グローバル
  SubCount = SubCount + int(1*frameRateSpeed);
  MasterSelectR();
  //処理内容が変わった
  if (pMasterFlg != MasterFlg) {
    pMasterFlg = MasterFlg;
    SubCount = 0;
    mouseKey = 2;
  }
  ImgBefore = get();//前回画像（こいつがかなりメモリ喰う←）

  //フェードアウト
  StratTime = StratTime + int(1*frameRateSpeed);
  if (StratTime < 30 && MasterFlg != -2 && MasterFlg != -3) frect(0, 0, 480, 640, #000000, (30-StratTime)*255/20);//画面変更(ry

  //動作速度管理
  if (OptionVariablefps){
    float a = 60.0;
    if (millis() - pmillis > 0) a = 1000/(millis() - pmillis)*frameRateSpeed;
    //println(a+" \t"+frameRateSpeed+" \t"+int(frameRate)+" \t"+int(frameRate*frameRateSpeed));
    if (a < 45 && frameRateSpeed < 6) {
      frameRateSpeed = frameRateSpeed + 1;
      frameRate(60/frameRateSpeed);
    } else if (a > 75 && frameRateSpeed > 1) {
      frameRateSpeed = frameRateSpeed - 1;
      frameRate(60/frameRateSpeed);
    }
    pmillis = millis();
  }else{
    frameRateSpeed = 2;
    frameRate(60/frameRateSpeed);
  }
}