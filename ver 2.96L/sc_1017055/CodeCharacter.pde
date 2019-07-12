//キャラクター画面関連
PImage[] ImgCharacter = new PImage[4];
String CharacterMsg = "";
int CharacterImgID = 1;
float  timeSum = 0.0;
int Fnum = 0, Cnum = 0;

//メイン
void MasterCharacter(){
    noTint();

    //初期化
    if (SubCount == 0){
        CharacterImgID = 1;

        //1か月前～昨日の課題の達成率を取得
        Cnum = 0;//課題の数
        Fnum = 0;//達成した課題数
        timeSum = 0.0;
        int y = (month() == 1) ? year() : year()-1;
        int m = (month() == 1) ? 12 : month()-1;
        for(int i = 0;i < ScheduleDate.length;i++){
            if(chDate(ScheduleDate[i],y+"/"+m+"/"+day()) && chDate(year()+"/"+month()+"/"+day(),ScheduleDate[i])){
                Cnum = Cnum + 1;
                if (SchedulePercent[i] == 1.0){
                    Fnum = Fnum + 1;
                    timeSum = timeSum + ScheduleStudyTime[i];
                }
            }
        }

        //メッセージ
        if (Cnum == 0){
            CharacterImgID = 3;
            CharacterMsg = "勉強した記録がないんだけど...\n記録していないだけ？\n";
        }else{
            float par = (0.0+Fnum)/Cnum;
            if (par > 0.98) {
                CharacterMsg = "その調子～\n今週も頑張ろ～！！\n";
            }else if (par > 0.90){
                CharacterMsg = "頑張ってるんじゃない？\n";
            }else if (par > 0.60){
                CharacterImgID = 2;
                CharacterMsg = "全然やってないじゃん\nもっとがんばろう？\n";
            }else if (par > 0.00){
                CharacterImgID = 2;
                CharacterMsg = "課題やれ\nとりあえず課題やれ\n";
            }else {
                CharacterImgID = 3;
                CharacterMsg = "記録していないだけよね...？\n勉強したほうがいいんじゃない？\n";
            }
        }

        //明日までの課題数を取得
        int num2 = 0;
        for(int i = 0;i < ScheduleDate.length;i++){
            if ((yesterday(ScheduleDate[i]).equals(year()+"/"+month()+"/"+day()) || ScheduleDate[i].equals(year()+"/"+month()+"/"+day())) && SchedulePercent[i] != 1) num2 = num2 + 1;
        }

        //メッセージ
        if (num2 == 0){
            CharacterMsg += "明日までの課題はないみたいね";
        }else{
            CharacterMsg += "明日までの課題が "+num2+"件 あるみたいね\n早めに終わらせましょ";
        }
    }

    //グラフィックス
    image(ImgCharacter[0], 0, 0);
    image(ImgCharacter[CharacterImgID], 120, 0);

    //メッセージ
    if (blimt(mouseX+480-SelectAddX,20,460) && blimt(mouseY,440,610)) {
        frect2(20, 460, 440, 150, MainColor, FillAlpha, 12);
        if (mouseKey == 1) SelectNext = 1;
    } else frect2(20, 460, 440, 150, MainColor, FillAlphaSub, 12);
    textSet(Font002, 18, LEFT, TOP);
    ftextb2(CharacterMsg, 40, 480, TextColor[1], TextColor[0], 560, 480);

    //記録
    if (blimt(mouseX+480-SelectAddX,20,200) && blimt(mouseY,20,170)) {
        frect2(20, 20, 180, 150, BarColor, FillAlpha, 12);
        if (mouseKey == 1) SelectNext = 500;
    } else frect2(20, 20, 180, 150, BarColor, FillAlphaSub, 12);
    textSet(Font001, 32, CENTER, CENTER);
    ftextb(nf(timeSum,1,1)+" h", 110, 60, TextColor[1], TextColor[0]);
    textSet(Font001, 48, CENTER, CENTER);
    if (Cnum != 0) ftextb(int(100*Fnum/Cnum)+"%", 110, 110, TextColor[1], TextColor[0]);
    else ftextb("NULL", 110, 110, TextColor[1], TextColor[0]);
}
