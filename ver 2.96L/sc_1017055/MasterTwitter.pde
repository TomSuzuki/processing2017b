//ツイッター
Twitter twitter;

//後で暗号化する＆別ファイルから読み込み
String consumerKey;
String consumerSecret;
String accessToken;
String accessTokenSecret;

//ツイートする
void tweet(String text) {
  try {
    twitter.updateStatus(text);
    NotCanTweet = false;
  }
  catch(TwitterException e) {
    NotCanTweet = true;
  }
}

//ツイートボタン
boolean NotCanTweet = false;
void TweetButton(int x, int y, String text, boolean t) {
  if (t) frect(x-1, y-1, 98, 30, #000000, 255);
  if (NotCanTweet) frect(x-1, y-1, 98, 30, #FF0000, 255);
  else frect(x-1, y-1, 98, 30, #ffffff, 255);
  if (blimt(mouseX, x, x+96) && blimt(mouseY, y, y+28) && t) { 
    frect(x, y, 96, 28, #0084B4, 255);
    if (mouseKey == 1) { 
      tweet(text);
      tFlg = false;
    }
  } else if (t) frect(x, y, 96, 28, #55acee, 255);
  else frect(x, y, 96, 28, #0084B4, 255);
  textSet(Font001, 16, CENTER, CENTER);
  ftextb("ツイート", x+48, y+14, TextColor[1], TextColor[0]);
}

//ロード
void LoadTwitterData() {
  String pass = FileTwitterSetting;

  //ロード
  MakeFileNoFile(pass, "\n\n\n\n");
  String[] a = loadStrings(pass);
  if (a.length > 3) {
    consumerKey = a[0];
    consumerSecret = a[1];
    accessToken = a[2];
    accessTokenSecret = a[3];
  }

  //ツイッターを使う準備
  ConfigurationBuilder builder = new ConfigurationBuilder();
  builder.setOAuthConsumerKey(consumerKey);
  builder.setOAuthConsumerSecret(consumerSecret);
  builder.setOAuthAccessToken(accessToken);
  builder.setOAuthAccessTokenSecret(accessTokenSecret);
  TwitterFactory factory = new TwitterFactory(builder.build());
  twitter = factory.getInstance();
}