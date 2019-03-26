
int activeQuantity=4;
Anim[] anims = new Anim[activeQuantity];

void playDraw() {
  for (int i=0 ; i<anims.length ; i++) {
    anims[i].nextFrame();
  }
}

class Anim {
  PImage[] frames = new PImage[0];
  float currentFrame=0;
  int placeNumber;
  float position=1;
  float[] coord;
  int loading=-1;
  int filling=-1;
  String[] files = new String[0];

  Anim() {
  }

  Anim(String folderUrl, int placeNumber) {
    this.placeNumber = placeNumber;
    this.coord = getCoordsFor(placeNumber);
    files = listDirectory(folderUrl);
    int nbImages=0;
    for (int i=0;i<files.length;i++) {
      if (!files[i].substring(files[i].length()-4).equals(".wav")) nbImages++;
    }
    frames = new PImage[nbImages];
    int j = 0;
    filling=-1;
    loading=-1;
  }

  void nextFrame() {
    if (filling>=0) {
      currentFrame = floor(position*(float)frames.length);
      if (currentFrame<frames.length) {
        image(frames[min(floor(currentFrame), filling)], coord[0], coord[1], coord[2], coord[3]);
        stroke(0x00);
        noFill();
        rect(coord[0], coord[1], coord[2], coord[3]);
      }
    }
    if (filling<frames.length) {
      loading++;
      if (loading<files.length) {
        if (!files[loading].substring(files[loading].length()-4).equals(".wav")) {
          filling++;
          frames[filling] = loadImage(files[loading]);
        }
        stroke(0x80, 0x80, 0x20);
        noFill();
        rect(coord[0], coord[1], coord[2], coord[3]);
        fill(0x80, 0x80, 0x20, 0x80);
        noStroke();
        rect(coord[0], coord[1], coord[2], coord[3]-max(0,coord[3]*filling/frames.length));
      }
    }
  }

  void setPosition(float p) {
    this.position=p;
  }
}

float[] getCoordsFor(int placeNumber) {
  float[] coo = new float[4];
  int rows = ceil(sqrt((float)activeQuantity));
  int cols = ceil((float)activeQuantity/rows);
  coo[0]=placeNumber%cols*floor((float)width/cols);//x
  coo[1]=floor(placeNumber/cols)*floor((float)height/rows);//y
  coo[2]=floor((float)width/cols);//w
  coo[3]=floor((float)height/rows);//h
  return coo;
}

String[] listDirectory(String url) {
  File folder=new File(url);
  File[] filesPath = folder.listFiles();
  String[] result = new String[filesPath.length];
  for (int i=0;i<filesPath.length;i++) {
    result[i]=filesPath[i].toString();
  }
  return result;
}

void loadV(int videoI, int i) {
  anims[videoI]=new Anim(dataPath("vids/" + i), videoI);
}

void position(int videoI, float p) {
  anims[videoI].setPosition(p);
}

