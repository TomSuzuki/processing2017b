//イメージの選択
int MasterSelectImageFlg = 0;
PImage[] ImageList;
String[] ImageName;
int SelectImageScroll = 0, pPosY = 0, SelectImage = -1;
void MasterSelectImage() {

  //リストの作成
  if (SubCount == 0) {
    SelectImageScroll = 0;
    SelectImage = -1;
    String[] extensions = {".png", ".jpg", ".bmp"};
    File cdirectory = new File(dataPath("image"));
    File[] fileList = cdirectory.listFiles();
    ImageList = new PImage[fileList.length];
    ImageName = new String[fileList.length];
    for (int i = 0; i < fileList.length; i++) for (String extension : extensions) if (fileList[i].getPath().endsWith(extension)) {
      ImageList[i] = loadImage(fileList[i].getAbsolutePath());
      ImageName[i] = FolderImages+fileList[i].getName();
    }
  }

  //背景
  background(MainColor);

  //スクロール
  if (mouseKey == 1 && abs(mouseY - pmouseY) > 1) mouseKey = 3;
  if (mouseKey == 3) SelectImageScroll = SelectImageScroll - (pmouseY - mouseY);
  if (SelectImageScroll < 320-pPosY) SelectImageScroll = 320-pPosY;
  if (SelectImageScroll > 0) SelectImageScroll = 0;

  //リストの表示＆処理
  if (mouseKey == 3) SelectImage = -1;
  if (mouseKey == 0 && SelectImage != -1) {
    if (MasterSelectImageFlg == 0) { 
      DelLine(FileInitialize, "backgroung-img");
      AddLine(FileInitialize, "backgroung-img,"+ImageName[SelectImage]);
    } else { 
      DelLine(FileInitialize, "backgroung-img-sub");
      AddLine(FileInitialize, "backgroung-img-sub,"+ImageName[SelectImage]);
    }
    LoadInitialize(FileInitialize);               //設定のロード
    MasterFlg = 5;
  }
  int PosX = 0, PosY = 0;
  for (int i = 0; i < ImageName.length; i++) if (ImageName[i].equals("") == false) {
    tint(255, 96);
    if (mouseX > PosX*220+40 && mouseX < PosX*220+40+180 && mouseY > PosY*260+96+SelectImageScroll && mouseY < PosY*260+96+SelectImageScroll+240 && mouseY > 64) {
      tint(255, 255);
      if (mouseKey == 1) SelectImage = i;
    }
    image(ImageList[i], PosX*220+40, PosY*260+96+SelectImageScroll, 180, 240);
    if (PosX == 0) PosX = PosX + 1;
    else {
      PosX = 0;
      PosY = PosY + 1;
    }
  }
  pPosY = PosY*260+96;

  //キャンセル
  frect(0, 0, 480, 64, MainColor, 255);
  if (SingleButton("キャンセル", 0)) MasterFlg = 5;
}