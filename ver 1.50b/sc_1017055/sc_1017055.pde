//1017055
//鈴木利武
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
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//　◆　記録　◆
//　（'17 07/03）　ブロック崩しでやりすぎた感があったのでこのスケジューラはまともなものを作ります。（目標）
//　（'17 07/05）　漢字変換ってまともかなぁ...（まぁ見た目は普通だよね？）
//　（'17 07/10）　またコメント地獄が...
//　（'17 07/10）　ニコニコ大百科を使って作った辞書がライセンス的に危なそうだったから自分で辞書作った。つかれた。※途中から、音楽聞きながら歌詞を書いただけ。←4時間くらいやってたから指いたい。
//　　　　　　　　 辞書見たらどんな曲聞いてたか多分わかると思う...
//　（'17 07/11）　ねむい（03:38）やっと ver 1.00だ...
//　（'17 07/13）　最近1日3時間しかねてないからいい処理思いつかない（ただの言い訳）
//　　　　　　　　 行数数えたら300行近く1日で増えたのか...（昨日の時点でほとんど完成してたと思ったのに....）
//
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//　◆　更新　◆
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

String TitleVer = "ver 1.50b";

//システム
PFont Font001, Font002;//（フォントデータ）
PImage Img000, Img001, Img002, Img003, ImgBefore, ImgTAB;  //イメージデータ（使ってないものある）
int mouseKey = 0;           //マウス
int BeforeFlg = 0;          //前回フラグ
int MasterFlg = -1;         //親フラグ
int pMasterFlg = -1;        //前回Flg
int BeforeFlg2 = -1;        //前回フラグ（２）
int BeforeFlgMemo = -1;     //メモ復帰フラグ
int BefireFlgNewSubject = -1;  //新規科目戻りフラグ
int BeforeFlgSelect = -1;   //セレクト復帰フラグ
int BeforeFlgSubject = -1;  //科目選択復帰フラグ
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
  size(480, 640, P2D);//画面サイズは指定されてるっていうね
  noStroke();//ノーストローク

  surface.setTitle("課題スケジューラ  "+TitleVer);//タイトル変更（バージョン入り）

  //画像のロード
  Img001 = loadImage("system/sys001.bmp"); //色の表？グラフ？洗濯用。違う、選択用
  Img002 = loadImage("system/sys002.png"); //×ボタン（仮？）←仮データが本データになることの方が多いから多分変えないな

  //その他ロード
  Font001 = loadFont("font/rounded-l-mplus-1c-black-48.vlw");//Roundedの1c-black（太字はやっぱりこれかな）
  //Font002 = loadFont("font/MeiryoUI-48.vlw");
  Font002 = loadFont("font/mgenplus-1cp-regular-48.vlw");//mgenplus-1cp-レギュラー（初めて使う気がする）
  //Font002 = loadFont("font/rounded-l-mplus-1c-black-48.vlw");
  textFont(Font001, 24);//最初に使ったとき遅い気がするから（結局ここで時間食うから変わらんけど）
  textFont(Font002, 24);//最初に使ったとき遅い気がするから（結局ここで時間食うから変わらんけど）

  //初期画面
  LoadInitialize("base.ini");               //設定のロード
  MasterStart();//一度描画（なんかおかしいのは気のせい？）
}

void draw() {
  surface.setSize(480, 640);  //画面サイズを強制

  if (SelectTimeR <= 30) translate(easing(SelectTimeR, 30, 480, 0, 103), 0);//画面変更のときにずらすやつ

  background(#000000);//背景
  noTint();//画像の透過系はReset

  switch(MasterFlg) {
  case -2://起動画面
    MasterStart();
    break;
  case -1://リロード
    LoadSubjectList("theme/subject.csv");     //科目のロード
    LoadInitialize("base.ini");               //設定のロード
    LoadSchedule("data/schedule/data.csv");   //スケジュールのロード
    ResetKeybode();                           //キーボードの初期化
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
  case 100://新規作成ボタン
    MasterSettingHomeworkReset();
    MasterFlg = 10;
    break;
  case 101://修正（修正後に元データは消す？）
    SettingHomeworkFlg = 1;
    MasterFlg = 10;
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
    String[] a = loadStrings(LinkFileName);
    link(a[0]);//リンク
    MasterFlg = 0;
    SelectTimeR = 31;
    SelectNext = -1;
    break;
  case 301://ランチャー
    String[] b = loadStrings(LinkFileName);
    try {//リンク実行
      Runtime r = Runtime.getRuntime();
      Process process = r.exec(b);
    }
    catch (Exception e) {
      //println(e);
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
  default://無かったら再起動
    MasterFlg = -1;
    break;
  }

  //切り替え関連グローバル
  SubCount = SubCount + 1;
  MasterSelectR();

  if (pMasterFlg != MasterFlg) {//処理内容が変わった
    pMasterFlg = MasterFlg;
    SubCount = 0;
    mouseKey = 2;
  }
  //ImgBefore = get();//前回画像

  //フェードアウト
  StratTime = StratTime + 1;
  if (StratTime < 30 && MasterFlg != -2) frect(0, 0, 480, 640, #000000, (30-StratTime)*255/20);//画面変更(ry
}
