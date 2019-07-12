//時間の入力
boolean tFlg = true;
//学習時間の入力
void MasterInputTime() {
  //初期化
  if (SubCount == 0) {
    Img000 = ImgBefore.get();
    tFlg = true;
  }

  //背景
  background(#000000);
  tint(64);
  image(Img000, 0, 0);

  //完了
  if (SingleButton("完了", 0)) {
    DelLine2(FileDataSchedule, SettingHomeworkpData);//削除
    SettingHomeworkpData = (SettingHomeworkYear+"/"+SettingHomeworkMonth+"/"+SettingHomeworkDay)+","+(SettingHomeworkHour+":"+SettingHomeworkMinute)+","+SettingHomeworkSubject+","+SettingHomeworkPar+","+SettingHomeworkStudyTime+","+SettingHomeworkMemo;
    AddLine(FileDataSchedule, SettingHomeworkpData);//新規作成
    LoadSchedule(FileDataSchedule);   //スケジュールのリロード
    MasterFlg = BeforeFlg;
  }

  //描画と処理
  int NowAng = int(SettingHomeworkStudyTime*360/24);
  fellipse(240, 320, 300, 300, TextColor[2], FillAlphaSub);
  fdrawPi(240, 320, 300, 0.5, 0.5+(0.0+NowAng)/360, MainColor, FillAlphaSub);
  fellipse(240, 320+150, 16, 16, TextColor[0], FillAlphaSub);
  fellipse(240, 320+150, 12, 12, MainColor, FillAlphaSub);
  fellipse(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), 24, 24, TextColor[0], FillAlphaSub);
  fellipse(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), 20, 20, MainColor, FillAlphaSub);
  if (dist(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), mouseX, mouseY) < 18 || mouseKey == 3) {
    fellipse(240+150*sin(radians(-NowAng)), 320+150*cos(radians(-NowAng)), 20, 20, TextColor[1], FillAlphaSub);
    if (mouseKey == 1) mouseKey =3;
  }
  if (mouseKey == 3) { 
    SettingHomeworkStudyTime = (360+180-degrees(atan2(240-mouseX, 320-mouseY)))%360*48/360;
    if (int(SettingHomeworkStudyTime)%2 == 0) SettingHomeworkStudyTime = 0.0 + int(SettingHomeworkStudyTime/2);
    else SettingHomeworkStudyTime = 0.0 + int(SettingHomeworkStudyTime/2) + 0.5;
  }
  if (SettingHomeworkStudyTime < 0) SettingHomeworkStudyTime = 0;
  if (SettingHomeworkStudyTime > 24) SettingHomeworkStudyTime = 24;
  String a = "0";
  if ((SettingHomeworkStudyTime*2)%2 == 1) a = "5";
  textSet(Font001, 48, CENTER, CENTER);
  ftextb(nf(int(SettingHomeworkStudyTime), 2)+"."+a+"h", 240, 320, TextColor[1], TextColor[0]);

  //ツイートボタン
  TweetButton(350, 530, (SettingHomeworkYear+"/"+nf(SettingHomeworkMonth, 2)+"/"+nf(SettingHomeworkDay, 2))+" "+(nf(SettingHomeworkHour, 2)+":"+nf(SettingHomeworkMinute, 2)) +"までの"+SettingHomeworkSubject+"の課題が完了しました。", tFlg);
}