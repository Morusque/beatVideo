
import processing.opengl.*;

import ddf.minim.*;
Minim minim;

import processing.video.*;
Capture myCapture;

int videoNumber;

int fRP = 50;// frame rate for playback
int fRR = 30;// frame rate for recording

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

boolean fullscreen = false;
boolean forceLocation = false;
PVector frameLoc = new PVector(20, 20);

void setup() {
  frameRate(fRP);
  size(700, 700);
  
  currentRec = new ArrayList();// TODO normalement pas besoin de ça, vérifier pourquoi ça plante en général au premier lancement

  frame.setBackground(new java.awt.Color(0, 0, 0));// set the background for when it's being displayed fullscreen
  frame.setResizable(true);
  // frame.setBounds(0, 0, displayWidth, displayHeight);

  minim = new Minim(this);  

  // to play video
  String[] animFolders = listDirectory(dataPath("vids"));
  videoNumber = animFolders.length;

  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);

  // from pure data
  oscP5.plug(this, "loadV", "/loadV");
  oscP5.plug(this, "record", "/record");
  oscP5.plug(this, "position", "/position");
  oscP5.plug(this, "handshake", "/handshake");

  // send number of videos
  videoQuantity(videoNumber);

  // to record video
  String[] cameras = Capture.list();
  for (int i=0; i<cameras.length;i++) {
    println(i+" "+cameras[i]);
  }

  // WARNING set fRR according to the chosen camera frame rate
  myCapture = new Capture(this, cameras[5]);

  //myCapture = new Capture(this, floor((float)width/2), floor((float)height/2), cameras[0], fRR);
  myCapture.start();

  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 512);
  // in = minim.getLineIn(Minim.STEREO, 512);

  for (int i=0 ; i<anims.length ; i++) {
    anims[i] = new Anim();
  }
}

void recOn(int i) {
  try { 
    OscMessage myOscMessage = new OscMessage("/recOn");
    myOscMessage.add((int)i);
    oscP5.send(myOscMessage, myRemoteLocation);
  }
  catch (Exception e) {
    println("recOn : "+e);
  }
}

void chaos() {
  try {   
    OscMessage myOscMessage = new OscMessage("/chaos");
    oscP5.send(myOscMessage, myRemoteLocation);
  }
  catch (Exception e) {
    println("chaos : "+e);
  }
}

void playSeq(int i) {
  try { 
    OscMessage myOscMessage = new OscMessage("/playSeq");
    myOscMessage.add((int)i);
    oscP5.send(myOscMessage, myRemoteLocation);
  }
  catch (Exception e) {
    println("playSeq : "+e);
  }
}

void videoQuantity(int i) {
  try { 
    OscMessage myOscMessage = new OscMessage("/nbVids");
    myOscMessage.add((int)i);
    oscP5.send(myOscMessage, myRemoteLocation);
  }
  catch (Exception e) {
    println("videoQuantity : "+e);
  }
}

void draw() {
  if (forceLocation) frame.setLocation(floor(frameLoc.x), floor(frameLoc.y));  
  recordDraw();  
  playDraw();
}

void stop()
{
  in.close();  
  minim.stop();
  super.stop();
}

void handshake() {
  println("handshake");
  videoQuantity(videoNumber);
  OscMessage myOscMessage = new OscMessage("/handshake");
  oscP5.send(myOscMessage, myRemoteLocation);
}

void keyPressed() {
  if (keyCode==82) {// r
    recOn(1);
  }
  if (keyCode==65) {// a
    chaos();
  }
  if (keyCode==80) {// p
    playSeq(1);
  }
  if (keyCode==83) {// s
    playSeq(0);
  }
}

void keyReleased() {
  if (keyCode==82) {// r
    recOn(0);
  }
}

boolean sketchFullScreen() {
  return fullscreen;
}

