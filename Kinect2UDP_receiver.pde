//run this app on a Mac to receive data from a Kinect V2 using the Kinect2UDP app running on a Windows computer with a Kinect V2 attached. Connect Windows and Mac via ethernet and set static IPs as in code

String version="Kinect2UDP Receiver - by Simon Biggs, 2018"; //version identification

import java.util.*; //libraries required - ensure these are installed
import hypermedia.net.*; //udp library

UDP udp;
int userID,jointType,theUser,theTime=millis(),prevMouseX,prevMouseY,mouseSensitivity=10;
float worldScale=0.5,udpScale=450.0,floor=720.0f,roof=-100.0f,stageleft=-900.0f,stageright=1500.0f,upstage=-1200.0f,downstage=700.0f,camX,camY,camZ,lookX,lookY,lookZ;
boolean tuning=true,fullScreen=false,userVisible=false,isMousePressed=false,recording=false,recorded=true,debugMode=false;
User user1,user2,user3,user4,user5,user6;
String DELIMITER=" ",jointName,myIP,kinectPos="screen";
color skeletonColour;
PVector receivedJointPos=new PVector();
int[] userList; //list of active Kinect skeletons

void setup() {
  size(1920,1080,P3D);  //rendering in 3D
  smooth();
  frameRate(50);
  background(0);
  myIP="10.0.0.2";  //set IP address from a static IP set in Preferences (ethernet)
  udp=new UDP(this, 8000, myIP); //initialise UDP connection
  udp.listen(true);
  cameraSetup();
  if(recording) initialiseRecording(); //if you want to record mocap data from Kinect set 'recording' var to true and give a unique name to filename in recording tab
  if(recorded) loadRecording(); //load recorded data (this is true by default in this example so you have something to look at - make 'recorded' var false to see live data from Kinect
  user1=new User(1,"user1",0,255,255); // initialise user objects to contain Kinect skeleton data
  user2=new User(2,"user2",255,50,50);
  user3=new User(3,"user3",0,255,0);
  user4=new User(4,"user4",0,0,255);
  user5=new User(5,"user5",255,255,0);
  user6=new User(6,"user6",255,0,255);
  if(tuning) { //true by default in this example, so you have something to see
    userVisible=true;
    debugMode=true;
    println("tuning");
  }
  println(version);
}

void draw() {
  background(0);
  cameraMove(); //you can move the camera by holding mouse down and moving it
  if(recorded) upDateRecorded(); //if using recorded data then load next frame
  user1.upDateUser(); //update all the user skeletons
  user2.upDateUser();
  user3.upDateUser();
  user4.upDateUser();
  user5.upDateUser();
  user6.upDateUser();
  if (tuning) tuningOn(); //if tuning true then draw floor mesh and skeletons
}

void keyPressed() {  //called whenever there's a keystroke
  if(key==CODED) {
    if(keyCode==UP) { // make skeletons visible/invisible
      userVisible=!userVisible;
      println("users skeletons=" + userVisible);
      return;
    }
    if(keyCode==LEFT) { // set camera back to original location
      resetCamera();
      return;
    }
    if(keyCode==DOWN) { // save kinect data recording when done
      saveTable(table, fileName);
      println("saving Kinect data to disk...");
      recording=false;
      return;
    }
  }
}

void cameraSetup() { //setup camera start position - options for Kinect located at screen or opposite screen (use tuning function to set parameters accordingly)
  if(kinectPos=="screen") {
    camX=displayWidth/6.2;  //set camera position to centre of screen
    camY=displayHeight/2.8;
    camZ=displayWidth*0.7;
    lookX=displayWidth/6.2;  //set camera orientation
    lookY=displayHeight/2.8;
    lookZ=0;
   }
   if(kinectPos=="projector") {
    camX=displayWidth/6.2;  //set camera position to centre of screen
    camY=displayHeight/2.15;
    camZ=displayWidth*-1.2;
    lookX=displayWidth/6.2;  //set camera orientation
    lookY=displayHeight/2.15;
    lookZ=180;
  }
}

void resetCamera() { //reset camera to original position
  if(kinectPos=="screen") {
    camX=displayWidth/6.2;  //set camera position to centre of screen
    camY=displayHeight/2.8;
    camZ=displayWidth*0.7;
    lookX=displayWidth/6.2;  //set camera orientation
    lookY=displayHeight/2.8;
    lookZ=0;
  }
  if(kinectPos=="projector") {
    camX=displayWidth/6.2;  //set camera position to centre of screen
    camY=displayHeight/2.15;
    camZ=displayWidth*-1.2;
    lookX=displayWidth/6.2;  //set camera orientation
    lookY=displayHeight/2.15;
    lookZ=180;
  }
  println("camera reset");
}

void cameraMove(){ //move camera if mouse pressed
  if(isMousePressed) adjustCamera();
  camera(camX,camY,camZ,lookX,lookY,lookZ,0,1,0);
}

void adjustCamera () { //adjust camera when moving it
  if(keyPressed){
    if(mouseY!=prevMouseY){
      if(mouseY-prevMouseY<=0) camZ+=min(mouseSensitivity,abs(mouseY-prevMouseY));
    else camZ-=min(mouseSensitivity,abs(mouseY-prevMouseY));}
  } else {
    if(mouseX!=prevMouseX){
      if((mouseX-prevMouseX)<0)lookX+=min(mouseSensitivity,abs(mouseX-prevMouseX));
      else lookX-=min(mouseSensitivity,abs(mouseX-prevMouseX));
      }
    if(mouseY!=prevMouseY){
    if(mouseY-prevMouseY<=0 )lookY+=min(mouseSensitivity,abs(mouseY-prevMouseY));
    else lookY-=min(mouseSensitivity,abs(mouseY-prevMouseY));
    }
  }
}

void tuningOn() { //display floor mesh, skeletons and skeleton location data
  float floorMarkerX=stageleft;
  float floorMarkerZ=upstage;
  float xStep=(stageright-stageleft)/20;
  float zStep=(upstage-downstage)/20;
  strokeWeight(2);
  for(int i=0;i<=20;i++) {
    if(i==10) {
      stroke(255,150,150);
    }else {
      stroke(0,255,0);
    }
    line(stageleft,floor,floorMarkerZ,stageright,floor,floorMarkerZ);
    floorMarkerZ=floorMarkerZ-zStep;
  }
  for(int i=0;i<=20;i++) {
    if(i==10) {
      stroke(255,150,150);
    }else {
      stroke(0,255,0);
    }
    line(floorMarkerX,floor,upstage,floorMarkerX,floor,downstage);
    floorMarkerX=floorMarkerX+xStep;
  }
}

void mousePressed(){
  if(!isMousePressed){
    prevMouseX=mouseX;
    prevMouseY=mouseY;
    isMousePressed=true;
  }
}

void mouseReleased(){
  isMousePressed=false;
}

boolean sketchFullScreen() {
  return fullScreen;
}


