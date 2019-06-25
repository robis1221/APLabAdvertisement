import kinect4WinSDK.*;
import kinect4WinSDK.SkeletonData;
import beads.*;
import org.jaudiolibs.beads.*;

//BEADS stuff
AudioContext ac = new AudioContext();
SamplePlayer sp1;
SamplePlayer sp2;

Gain masterGain; 

Gain sampleGain;
Glide gainGlide_s;
Glide rateValue;

Gain sampleGain2;
Glide gainGlide_s2;
Glide rateValue2;


boolean[] violinSelected=new boolean[2];
boolean[] drumSelected=new boolean[2];


float[] rate_test = new float[2];
float[] rate_test2 = new float[2];
float[] handDistance = new float[2];
float[] volume_h = new float[2];


//KINECT STUFF

Kinect kinect;
ArrayList <SkeletonData> bodies;


PImage mask, 
  infoText;

Part emitter;

float handDistance_01 = 200, 
  pHandDistance = 200, 
  musicPlay =0, 
  handHolding = 0, 
  skeletonId = 0;

boolean handSelected = false, 
  handIsSelecting = false;

boolean showZoneOne = false, 
  showZoneTwo = false;

int boneId=0, 
  testtest=0;

PVector rHand, 
  lHand;

void setup() {
  mask=loadImage("text.png");
  emitter = new Part(mask);
  size(800, 600, P3D);
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();
  infoText=loadImage("infotext.png");

  //beads


  masterGain = new Gain(ac, 1, 1); 

  try {
    sp1 = new SamplePlayer(ac, new Sample(sketchPath("") + "data/loop-1-80-bpm_01.wav"));
    sp2 = new SamplePlayer(ac, new Sample (sketchPath("") + "data/violin.wav"));
  }
  catch(Exception e) {
    println("Exception while attempting to load sample!");
    e.printStackTrace();
    exit();
  }

  sp1.setKillOnEnd(false);
  sp1.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);

  sp2.setKillOnEnd(false);
  sp2.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);

  rateValue = new Glide(ac, 1, 1);
  sp1.setRate(rateValue);

  rateValue2 = new Glide(ac, 1, 1);
  sp2.setRate(rateValue2);

  gainGlide_s = new Glide(ac, 0.0, 1);
  sampleGain = new Gain(ac, 1, gainGlide_s);
  sampleGain.addInput(sp1);

  gainGlide_s2 = new Glide(ac, 0.0, 1);
  sampleGain2 = new Gain(ac, 1, gainGlide_s2);
  sampleGain2.addInput(sp2);


  masterGain.addInput(sampleGain2);
  masterGain.addInput(sampleGain); 

  ac.out.addInput(masterGain);
}


void draw() {
  showZoneOne=false;
  showZoneTwo=false;

  background(0);
  skeletonId=0;

  for (int i=0; i<bodies.size(); i++) {  // going through the skeletons that the kinect has recognized

    if (bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].z==0) {
      testtest++;
      if (testtest>10) {
        bodies.remove(i);
        testtest=0;
      }
    } else {


      //loading the points
      //left arm
      PVector leftHand = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].z/100);
      PVector leftElbow = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT].z/100);
      PVector leftShoulder = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT].z/100);
      //right arm
      PVector rightHand = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].z/100);
      PVector rightElbow = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT].z/100);
      PVector rightShoulder = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT].z/100);
      //center
      PVector head = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HEAD].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HEAD].y*height+10, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HEAD].z/100);
      PVector neck = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER].z/100);
      PVector pelvis = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HIP_CENTER].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HIP_CENTER].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HIP_CENTER].z/100);
      //left leg
      PVector leftKnee = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_KNEE_LEFT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_KNEE_LEFT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_KNEE_LEFT].z/100);
      PVector leftAnkle = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT].z/100);
      PVector leftFoot = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_FOOT_LEFT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_FOOT_LEFT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_FOOT_LEFT].z/100);
      //right leg
      PVector rightKnee = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT].z/100);
      PVector rightAnkle = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT].z/100);
      PVector rightFoot = new PVector(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT].x*width, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT].y*height, bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT].z/100);


      //emitting particles
      boneId=0;
      //left arm
      float lerpArmLength = 5;
      emitter.make(leftShoulder);
      emitter.make(leftElbow);
      emitter.make(leftHand);
      for (float ii=0; ii<lerpArmLength; ii++) {
        PVector lerpedPointOne = new PVector(lerp(leftShoulder.x, leftElbow.x, ii/lerpArmLength), lerp(leftShoulder.y, leftElbow.y, ii/lerpArmLength), lerp(leftShoulder.z, leftElbow.z, ii/lerpArmLength));
        PVector lerpedPointTwo = new PVector(lerp(leftHand.x, leftElbow.x, ii/lerpArmLength), lerp(leftHand.y, leftElbow.y, ii/lerpArmLength), lerp(leftHand.z, leftElbow.z, ii/lerpArmLength));
        PVector lerpedPointThree = new PVector(lerp(leftShoulder.x, neck.x, ii/lerpArmLength), lerp(leftShoulder.y, neck.y, ii/lerpArmLength), lerp(leftShoulder.z, neck.z, ii/lerpArmLength));

        emitter.make(lerpedPointTwo);
        emitter.make(lerpedPointOne);
        emitter.make(lerpedPointThree);
      }
      //right arm
      emitter.make(rightShoulder);
      emitter.make(rightElbow);
      emitter.make(rightHand);
      for (float ii=0; ii<lerpArmLength; ii++) {
        PVector lerpedPointOne = new PVector(lerp(rightShoulder.x, rightElbow.x, ii/lerpArmLength), lerp(rightShoulder.y, rightElbow.y, ii/lerpArmLength), lerp(rightShoulder.z, rightElbow.z, ii/lerpArmLength));
        PVector lerpedPointTwo = new PVector(lerp(rightHand.x, rightElbow.x, ii/lerpArmLength), lerp(rightHand.y, rightElbow.y, ii/lerpArmLength), lerp(rightHand.z, rightElbow.z, ii/lerpArmLength));
        PVector lerpedPointThree = new PVector(lerp(rightShoulder.x, neck.x, ii/lerpArmLength), lerp(rightShoulder.y, neck.y, ii/lerpArmLength), lerp(rightShoulder.z, neck.z, ii/lerpArmLength));

        emitter.make(lerpedPointTwo);
        emitter.make(lerpedPointOne);
        emitter.make(lerpedPointThree);
      }

      //center
      float lerpCenterLength = 3;
      emitter.make(head);
      emitter.make(neck);
      emitter.make(pelvis);
      for (float ii=0; ii<lerpCenterLength; ii++) {
        PVector lerpedPointOne = new PVector(lerp(head.x, neck.x, ii/lerpCenterLength), lerp(head.y, neck.y, ii/lerpCenterLength), lerp(head.z, neck.z, ii/lerpCenterLength));
        PVector lerpedPointTwo = new PVector(lerp(neck.x, pelvis.x, ii/lerpCenterLength), lerp(neck.y, pelvis.y, ii/lerpCenterLength), lerp(neck.z, pelvis.z, ii/lerpCenterLength));

        emitter.make(lerpedPointTwo);
        emitter.make(lerpedPointOne);
      }

      float lerpLegLength = 5;
      //left leg
      emitter.make(leftKnee);
      emitter.make(leftAnkle);
      emitter.make(leftFoot);
      for (float ii=0; ii<lerpLegLength; ii++) {
        PVector lerpedPointOne = new PVector(lerp(pelvis.x, leftKnee.x, ii/lerpLegLength), lerp(pelvis.y, leftKnee.y, ii/lerpLegLength), lerp(pelvis.z, leftElbow.z, ii/lerpLegLength));
        PVector lerpedPointTwo = new PVector(lerp(leftKnee.x, leftFoot.x, ii/lerpLegLength), lerp(leftKnee.y, leftFoot.y, ii/lerpLegLength), lerp(leftKnee.z, leftFoot.z, ii/lerpLegLength));
        PVector lerpedPointThree = new PVector(lerp(leftAnkle.x, leftFoot.x, ii/lerpLegLength), lerp(leftAnkle.y, leftFoot.y, ii/lerpLegLength), lerp(leftAnkle.z, leftFoot.z, ii/lerpLegLength));

        emitter.make(lerpedPointTwo);
        emitter.make(lerpedPointOne);
        emitter.make(lerpedPointThree);
      }

      //right leg
      emitter.make(rightKnee);
      emitter.make(rightAnkle);
      emitter.make(rightFoot);
      for (float ii=0; ii<lerpLegLength; ii++) {
        PVector lerpedPointOne = new PVector(lerp(pelvis.x, rightKnee.x, ii/lerpLegLength), lerp(pelvis.y, rightKnee.y, ii/lerpLegLength), lerp(pelvis.z, rightElbow.z, ii/lerpLegLength));
        PVector lerpedPointTwo = new PVector(lerp(rightKnee.x, rightFoot.x, ii/lerpLegLength), lerp(rightKnee.y, rightFoot.y, ii/lerpLegLength), lerp(rightKnee.z, rightFoot.z, ii/lerpLegLength));
        PVector lerpedPointThree = new PVector(lerp(rightAnkle.x, rightFoot.x, ii/lerpLegLength), lerp(rightAnkle.y, rightFoot.y, ii/lerpLegLength), lerp(rightAnkle.z, rightFoot.z, ii/lerpLegLength));

        emitter.make(lerpedPointTwo);
        emitter.make(lerpedPointOne);
        emitter.make(lerpedPointThree);
      }


      //for the sound


      volume_h[i] = constrain(((pelvis.y+20) - leftHand.y) / 100, 0.0, 5);

      handDistance[i]=dist(rightHand.x, rightHand.y, rightHand.z, leftHand.x, leftHand.y, leftHand.z);

      if (pelvis.x > 2*width/3 && pelvis.z > 130) {
        violinSelected[i]=true;
        rate_test2[i] = constrain(handDistance[i] / 300, 0, 2);
      } else
        violinSelected[i]=false;


      if (pelvis.x < width/3 && pelvis.z > 130) {
        drumSelected[i]=true;
        rate_test[i] = constrain(handDistance[i] / 300, 0, 2);
      } else
        drumSelected[i]=false;  

      skeletonId++;

      infoPoint(pelvis);

      //end of loop!
    }
  }


  emitter.show();

  showInfoPoint();  

  if (drumSelected[0]||drumSelected[1]) {
    ac.start();

    if (drumSelected[0]) {
      rateValue.setValue(rate_test[0]);
      gainGlide_s.setValue(5);
    }

    if (drumSelected[1]) {
      rateValue.setValue(rate_test[1]);
      gainGlide_s.setValue(5);
    }
    sp1.start();
  } else 
  gainGlide_s.setValue(0);

  if (violinSelected[0]||violinSelected[1]) {
    ac.start();

    if (violinSelected[0]) {
      rateValue2.setValue(rate_test2[0]);
      gainGlide_s2.setValue(5);
    }
    if (violinSelected[1]) {
      rateValue.setValue(rate_test2[1]);
      gainGlide_s2.setValue(5);
    }
    sp2.start();
  } else
    gainGlide_s2.setValue(0);
}

/*
void keypressed() {
 for (int i =0; i>bodies.size(); i++) {
 bodies.remove(i);
 }
 ac.stop();
 }
 */

void infoPoint(PVector test) {
  //println("hello - there is an infopoint here!");
  int zClose = 0;
  int zFar = 110;
  int variation =200;
  int x1Close = (width/6)-variation;
  int x1Far = (width/6)+variation;
  int x2Close = (5*width/6)-variation;
  int x2Far = (5*width/6)+variation;
  if (test.z>zClose && test.z<zFar) {
    //println("z works");
    if (test.x>x1Close && test.x<x1Far) {
      //println("y works");
      showZoneOne=true;
    }
    if (test.x>x2Close && test.x<x2Far) {
      showZoneTwo=true;
    }
  }
}

void showInfoPoint() {
  imageMode(CENTER);
  if (showZoneTwo) {
    tint(255, 150);
    image(infoText, 5*width/6-20, 50+(infoText.height/2));
  }

  if (showZoneOne) {
    tint(255, 150);
    image(infoText, width/6+20, 50+(infoText.height/2));
  }
  tint(255);
  imageMode(CORNER);
} 

// part of the kinect dependables

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}