
boolean recording = false;
int frameNb=0;

AudioInput in;
AudioRecorder recorder;

ArrayList currentRec;

float recordingTime = 0;

void captureEvent(Capture myCapture) {
  myCapture.read();
}

void recordDraw() {
  pushMatrix();
  scale(-1.0, 1.0);
  image(myCapture, -width, 0, width, height);
  popMatrix();
  if (beingSaved>0) {
    fill(0xFF-(float)0xFF*beingSaved/currentRec.size());
    stroke(0xFF);
    ellipse(width/2, height/2, width/2, height/2);
    triangle(width/2-width/7, height/2-height/7, width/2+width/7, height/2-height/7, width/2, height/2);
    triangle(width/2-width/7, height/2+height/7, width/2+width/7, height/2+height/7, width/2, height/2);
  }
  if (recording) {
    recordingTime += 1.0/fRP;
    while (recordingTime > 1.0/fRR) {
      recordingTime -= 1.0/fRR;
      currentRec.add(myCapture.get());
      frameNb++;
      if (frameNb>30.0*fRP) record(0);// limit to 30 seconds
    }
  }
  noStroke();
  fill(0x0, 0xE0);
  if (recording)  fill(0xFF, 0x00, 0x00, 0xB0);
  rect(0, 0, width, height);
}

int beingSaved = 0;

void record(int state) {
  if (state==1) {// start
    if (!recording && beingSaved == 0) {
      recording=true;
      recorder = minim.createRecorder(in, "data/vids/"+videoNumber+"/00.wav", true);
      recorder.beginRecord();
      frameNb=0;
      currentRec = new ArrayList();
      recordingTime = 0;
    }
  }
  else if (state==0) {// stop
    if (recording && beingSaved == 0) {
      beingSaved = currentRec.size();
      recorder.endRecord();
      recording=false;
      if (currentRec.size()>=5) {// ne pas enregistrer si moins de cinq images
        for (int i=0;i<currentRec.size();i++) {
          beingSaved = currentRec.size()-i;
          ((PImage)currentRec.get(i)).save("data/vids/"+videoNumber+"/"+nf(i, 5)+".png");
        }
        recorder.save();
        videoNumber++;
        videoQuantity(videoNumber);
      }
      beingSaved = 0;
    }
  }
}

