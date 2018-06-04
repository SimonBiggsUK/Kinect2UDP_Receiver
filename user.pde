class User { //this class builds and displays user skeletons, taking data from either live Kinect V2 over UDP or from a recorded file of Kinect V2 mocap data
  color Colour;
  HashMap mJoints;
  int mUserId,red,green,blue,sampleSpace=5;
  PVector startLoc,defaultLoc,SPINE_BASE,SPINE_MID,NECK,HEAD,LEFT_SHOULDER,LEFT_ELBOW,LEFT_WRIST,LEFT_HAND,RIGHT_SHOULDER,RIGHT_ELBOW,RIGHT_WRIST,RIGHT_HAND,LEFT_HIP,LEFT_KNEE,LEFT_ANKLE,LEFT_FOOT,RIGHT_HIP,RIGHT_KNEE,RIGHT_ANKLE,RIGHT_FOOT,SPINE_SHOULDER,LEFT_HANDTIP,LEFT_THUMB,RIGHT_HANDTIP,RIGHT_THUMB;
  String myName;
  boolean myState;
  
  User(int _userId,String _name,int r,int g,int b) { //create a skeleton
    mUserId=_userId;
    myName=_name;
    red=r;
    green=g;
    blue=b;
    Colour=color(red, green, blue);
    myState=false;
    mJoints=new HashMap(); //a hashmap to contain all the joints
    defaultLoc=new PVector(0,0,0); //just some dummy data, off-screen
    startLoc=new PVector(10000,10000,10000);
    mJoints.put("SPINE_BASE",defaultLoc); //put the skeleton off-screen ready for use - think of it like a space suit hanging up, ready for the user to put on when they walk into the Kinect V2 sensor field
    mJoints.put("SPINE_MID",defaultLoc);
    mJoints.put("NECK",defaultLoc);
    mJoints.put("HEAD",defaultLoc);
    mJoints.put("LEFT_SHOULDER",defaultLoc);
    mJoints.put("LEFT_ELBOW",defaultLoc);
    mJoints.put("LEFT_WRIST",defaultLoc);
    mJoints.put("LEFT_HAND",defaultLoc);
    mJoints.put("RIGHT_SHOULDER",defaultLoc);
    mJoints.put("RIGHT_ELBOW",defaultLoc);
    mJoints.put("RIGHT_WRIST",defaultLoc);
    mJoints.put("RIGHT_HAND",defaultLoc);
    mJoints.put("LEFT_HIP",defaultLoc);
    mJoints.put("LEFT_KNEE",defaultLoc);
    mJoints.put("LEFT_ANKLE",defaultLoc);
    mJoints.put("LEFT_FOOT",defaultLoc);
    mJoints.put("RIGHT_HIP",defaultLoc);
    mJoints.put("RIGHT_KNEE",defaultLoc);
    mJoints.put("RIGHT_ANKLE",defaultLoc);
    mJoints.put("RIGHT_FOOT",defaultLoc);
    mJoints.put("SPINE_SHOULDER",defaultLoc);
    mJoints.put("LEFT_HANDTIP",defaultLoc);
    mJoints.put("LEFT_THUMB",defaultLoc);
    mJoints.put("RIGHT_HANDTIP",defaultLoc);
    mJoints.put("RIGHT_THUMB",defaultLoc);
  }

  void addJoint(String _key,PVector _val) { //this is where we receive data from the Kinect V2 or recorded data file
    mJoints.put(_key,_val);
  }
  
  void upDateUser() {  //function to update skeleton joints and display them
    if(myState) {
      updateJoints(); //update all the joints
      if(recording) recordSkeleton(); //if recording then record the data
      if(userVisible) drawSkeleton(); //if user is visible then draw the skeleton (default if tuning on)
    }
  }
  
  void drawSkeleton() {  //draw the skeleton as bones between joints
    stroke(Colour);
    strokeWeight(worldScale*10);
    if(HEAD!=null && NECK!=null) line(HEAD.x,HEAD.y,HEAD.z,NECK.x,NECK.y,NECK.z);
    if(SPINE_SHOULDER!=null && NECK!=null) line(NECK.x,NECK.y,NECK.z,SPINE_SHOULDER.x,SPINE_SHOULDER.y,SPINE_SHOULDER.z);
    if(SPINE_SHOULDER!=null && SPINE_MID!=null) line(SPINE_MID.x,SPINE_MID.y,SPINE_MID.z,SPINE_SHOULDER.x,SPINE_SHOULDER.y,SPINE_SHOULDER.z);
    if(SPINE_BASE!=null && SPINE_MID!=null) line(SPINE_MID.x,SPINE_MID.y,SPINE_MID.z,SPINE_BASE.x,SPINE_BASE.y,SPINE_BASE.z);
    if(SPINE_SHOULDER!=null && LEFT_SHOULDER!=null) line(LEFT_SHOULDER.x,LEFT_SHOULDER.y,LEFT_SHOULDER.z,SPINE_SHOULDER.x,SPINE_SHOULDER.y,SPINE_SHOULDER.z);
    if(LEFT_ELBOW!=null && LEFT_SHOULDER!=null) line(LEFT_SHOULDER.x,LEFT_SHOULDER.y,LEFT_SHOULDER.z,LEFT_ELBOW.x,LEFT_ELBOW.y,LEFT_ELBOW.z);
    if(LEFT_ELBOW!=null && LEFT_WRIST!=null) line(LEFT_WRIST.x,LEFT_WRIST.y,LEFT_WRIST.z,LEFT_ELBOW.x,LEFT_ELBOW.y,LEFT_ELBOW.z);
    if(LEFT_WRIST!=null && LEFT_HAND!=null) line(LEFT_WRIST.x,LEFT_WRIST.y,LEFT_WRIST.z,LEFT_HAND.x,LEFT_HAND.y,LEFT_HAND.z);
    if(LEFT_THUMB!=null && LEFT_HAND!=null) line(LEFT_THUMB.x,LEFT_THUMB.y,LEFT_THUMB.z,LEFT_HAND.x,LEFT_HAND.y,LEFT_HAND.z);
    if(LEFT_HANDTIP!=null && LEFT_HAND!=null) line(LEFT_HANDTIP.x,LEFT_HANDTIP.y,LEFT_HANDTIP.z,LEFT_HAND.x,LEFT_HAND.y,LEFT_HAND.z);
    if(SPINE_SHOULDER!=null && RIGHT_SHOULDER!=null) line(RIGHT_SHOULDER.x,RIGHT_SHOULDER.y,RIGHT_SHOULDER.z,SPINE_SHOULDER.x,SPINE_SHOULDER.y,SPINE_SHOULDER.z);
    if(RIGHT_ELBOW!=null && RIGHT_SHOULDER!=null) line(RIGHT_SHOULDER.x,RIGHT_SHOULDER.y,RIGHT_SHOULDER.z,RIGHT_ELBOW.x,RIGHT_ELBOW.y,RIGHT_ELBOW.z);
    if(RIGHT_ELBOW!=null && RIGHT_WRIST!=null) line(RIGHT_WRIST.x,RIGHT_WRIST.y,RIGHT_WRIST.z,RIGHT_ELBOW.x,RIGHT_ELBOW.y,RIGHT_ELBOW.z);
    if(RIGHT_WRIST!=null && RIGHT_HAND!=null) line(RIGHT_WRIST.x,RIGHT_WRIST.y,RIGHT_WRIST.z,RIGHT_HAND.x,RIGHT_HAND.y,RIGHT_HAND.z);
    if(RIGHT_THUMB!=null && RIGHT_HAND!=null) line(RIGHT_THUMB.x,RIGHT_THUMB.y,RIGHT_THUMB.z,RIGHT_HAND.x,RIGHT_HAND.y,RIGHT_HAND.z);
    if(RIGHT_HANDTIP!=null && RIGHT_HAND!=null) line(RIGHT_HANDTIP.x,RIGHT_HANDTIP.y,RIGHT_HANDTIP.z,RIGHT_HAND.x,RIGHT_HAND.y,RIGHT_HAND.z);
    if(SPINE_BASE!=null && LEFT_HIP!=null) line(LEFT_HIP.x,LEFT_HIP.y,LEFT_HIP.z,SPINE_BASE.x,SPINE_BASE.y,SPINE_BASE.z);
    if(LEFT_KNEE!=null && LEFT_HIP!=null) line(LEFT_HIP.x,LEFT_HIP.y,LEFT_HIP.z,LEFT_KNEE.x,LEFT_KNEE.y,LEFT_KNEE.z);
    if(LEFT_KNEE!=null && LEFT_ANKLE!=null) line(LEFT_ANKLE.x,LEFT_ANKLE.y,LEFT_ANKLE.z,LEFT_KNEE.x,LEFT_KNEE.y,LEFT_KNEE.z);
    if(LEFT_FOOT!=null && LEFT_ANKLE!=null) line(LEFT_ANKLE.x,LEFT_ANKLE.y,LEFT_ANKLE.z,LEFT_FOOT.x,LEFT_FOOT.y,LEFT_FOOT.z);
    if(SPINE_BASE!=null && RIGHT_HIP!=null) line(RIGHT_HIP.x,RIGHT_HIP.y,RIGHT_HIP.z,SPINE_BASE.x,SPINE_BASE.y,SPINE_BASE.z);
    if(RIGHT_KNEE!=null && RIGHT_HIP!=null) line(RIGHT_KNEE.x,RIGHT_KNEE.y,RIGHT_KNEE.z,RIGHT_HIP.x,RIGHT_HIP.y,RIGHT_HIP.z);
    if(RIGHT_KNEE!=null && RIGHT_ANKLE!=null) line(RIGHT_KNEE.x,RIGHT_KNEE.y,RIGHT_KNEE.z,RIGHT_ANKLE.x,RIGHT_ANKLE.y,RIGHT_ANKLE.z);
    if(RIGHT_FOOT!=null && RIGHT_ANKLE!=null) line(RIGHT_FOOT.x,RIGHT_FOOT.y,RIGHT_FOOT.z,RIGHT_ANKLE.x,RIGHT_ANKLE.y,RIGHT_ANKLE.z);
    if(tuning) { //draw lines showing position of skeleton on floor and with x and z coordinate displayed
      strokeWeight(2);
      line(stageleft,floor,SPINE_BASE.z,stageright,floor,SPINE_BASE.z);
      line(SPINE_BASE.x,floor,upstage,SPINE_BASE.x,floor,downstage);
      textSize(60);
      fill(255,255,255);
      if(kinectPos!="side") {
        text("x " + int(SPINE_BASE.x),HEAD.x-300,floor,SPINE_BASE.z);
        text("z " + int(HEAD.z),SPINE_BASE.x,floor,SPINE_BASE.z+200);
      }
    }
  }
  
  void updateJoints() { //update all the joints
    SPINE_BASE=(PVector)mJoints.get("SPINE_BASE");  // head
    SPINE_MID=(PVector)mJoints.get("SPINE_MID");  // head
    NECK=(PVector)mJoints.get("NECK");  // head
    HEAD=(PVector)mJoints.get("HEAD");   // neck
    LEFT_SHOULDER=(PVector)mJoints.get("LEFT_SHOULDER");  // left shoulder
    LEFT_ELBOW=(PVector)mJoints.get("LEFT_ELBOW");  // left elbow
    LEFT_WRIST=(PVector)mJoints.get("LEFT_WRIST");  //left hand
    LEFT_HAND=(PVector)mJoints.get("LEFT_HAND");  // right shoulder
    RIGHT_SHOULDER=(PVector) mJoints.get("RIGHT_SHOULDER");  // right elbow
    RIGHT_ELBOW=(PVector)mJoints.get("RIGHT_ELBOW");  // right hand
    RIGHT_WRIST=(PVector)mJoints.get("RIGHT_WRIST");  // torso
    RIGHT_HAND=(PVector)mJoints.get("RIGHT_HAND");  // left hip
    LEFT_HIP=(PVector)mJoints.get("LEFT_HIP");  // left knee
    LEFT_KNEE=(PVector)mJoints.get("LEFT_KNEE");  // left foot
    LEFT_ANKLE=(PVector)mJoints.get("LEFT_ANKLE");  // right hip
    LEFT_FOOT=(PVector)mJoints.get("LEFT_FOOT");  // right knee
    RIGHT_HIP=(PVector)mJoints.get("RIGHT_HIP");  // right foot
    RIGHT_KNEE=(PVector)mJoints.get("RIGHT_KNEE");  // right foot
    RIGHT_ANKLE=(PVector)mJoints.get("RIGHT_ANKLE");  // right foot
    RIGHT_FOOT=(PVector)mJoints.get("RIGHT_FOOT");  // right foot
    SPINE_SHOULDER=(PVector)mJoints.get("SPINE_SHOULDER");  // right foot
    LEFT_HANDTIP=(PVector)mJoints.get("LEFT_HANDTIP");  // right foot
    LEFT_THUMB=(PVector)mJoints.get("LEFT_THUMB");  // right foot
    RIGHT_HANDTIP=(PVector)mJoints.get("RIGHT_HANDTIP");  // right foot
    RIGHT_THUMB=(PVector)mJoints.get("RIGHT_THUMB");  // right foot
  }
  
  void changeState(boolean s) { //set the skeleton to true or false
    myState=s;
  }
  
  void deleteUser() {  // delete users when they exit or are lost
    myState=false;
    SPINE_BASE=defaultLoc;  // head
    SPINE_MID=defaultLoc; //neck
    NECK=defaultLoc;  // left shoulder
    HEAD=defaultLoc;  // left shoulder
    LEFT_SHOULDER=defaultLoc;  // left upperArm
    LEFT_ELBOW=defaultLoc;  //left foreArm
    LEFT_WRIST=defaultLoc;  // right shoulder
    LEFT_HAND=defaultLoc;  // right upper arm
    RIGHT_SHOULDER=defaultLoc;  // right lower arm
    RIGHT_ELBOW=defaultLoc;  // torso
    RIGHT_WRIST=defaultLoc;  // left hip
    RIGHT_HAND=defaultLoc;  // left thigh
    LEFT_HIP=defaultLoc;  // left calf
    LEFT_KNEE=defaultLoc;  // right hip
    LEFT_ANKLE=defaultLoc;  // right thigh
    LEFT_FOOT=defaultLoc;  // right calf
    RIGHT_HIP=defaultLoc;  // right calf
    RIGHT_KNEE=defaultLoc;  // right calf
    RIGHT_ANKLE=defaultLoc;  // right calf
    RIGHT_FOOT=defaultLoc;  // right calf
    SPINE_SHOULDER=defaultLoc;  // right calf
    LEFT_HANDTIP=defaultLoc;  // right calf
    LEFT_THUMB=defaultLoc;  // right calf
    RIGHT_HANDTIP=defaultLoc;  // right calf
    RIGHT_THUMB=defaultLoc;  // right calf
    updateJoints();
  }

  void recordSkeleton(){ //record skeleton data, a frame at a time
    int tempTime=millis();
    TableRow newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "SPINE_BASE");
    newRow.setFloat("x", SPINE_BASE.x);
    newRow.setFloat("y", SPINE_BASE.y);
    newRow.setFloat("z", SPINE_BASE.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "SPINE_MID");
    newRow.setFloat("x", SPINE_MID.x);
    newRow.setFloat("y", SPINE_MID.y);
    newRow.setFloat("z", SPINE_MID.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "NECK");
    newRow.setFloat("x", NECK.x);
    newRow.setFloat("y", NECK.y);
    newRow.setFloat("z", NECK.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "HEAD");
    newRow.setFloat("x", HEAD.x);
    newRow.setFloat("y", HEAD.y);
    newRow.setFloat("z", HEAD.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_SHOULDER");
    newRow.setFloat("x", LEFT_SHOULDER.x);
    newRow.setFloat("y", LEFT_SHOULDER.y);
    newRow.setFloat("z", LEFT_SHOULDER.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_ELBOW");
    newRow.setFloat("x", LEFT_ELBOW.x);
    newRow.setFloat("y", LEFT_ELBOW.y);
    newRow.setFloat("z", LEFT_ELBOW.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_WRIST");
    newRow.setFloat("x", LEFT_WRIST.x);
    newRow.setFloat("y", LEFT_WRIST.y);
    newRow.setFloat("z", LEFT_WRIST.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_HAND");
    newRow.setFloat("x", LEFT_HAND.x);
    newRow.setFloat("y", LEFT_HAND.y);
    newRow.setFloat("z", LEFT_HAND.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_SHOULDER");
    newRow.setFloat("x", RIGHT_SHOULDER.x);
    newRow.setFloat("y", RIGHT_SHOULDER.y);
    newRow.setFloat("z", RIGHT_SHOULDER.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_ELBOW");
    newRow.setFloat("x", RIGHT_ELBOW.x);
    newRow.setFloat("y", RIGHT_ELBOW.y);
    newRow.setFloat("z", RIGHT_ELBOW.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_WRIST");
    newRow.setFloat("x", RIGHT_WRIST.x);
    newRow.setFloat("y", RIGHT_WRIST.y);
    newRow.setFloat("z", RIGHT_WRIST.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_HAND");
    newRow.setFloat("x", RIGHT_HAND.x);
    newRow.setFloat("y", RIGHT_HAND.y);
    newRow.setFloat("z", RIGHT_HAND.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_HIP");
    newRow.setFloat("x", LEFT_HIP.x);
    newRow.setFloat("y", LEFT_HIP.y);
    newRow.setFloat("z", LEFT_HIP.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_KNEE");
    newRow.setFloat("x", LEFT_KNEE.x);
    newRow.setFloat("y", LEFT_KNEE.y);
    newRow.setFloat("z", LEFT_KNEE.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_ANKLE");
    newRow.setFloat("x", LEFT_ANKLE.x);
    newRow.setFloat("y", LEFT_ANKLE.y);
    newRow.setFloat("z", LEFT_ANKLE.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_FOOT");
    newRow.setFloat("x", LEFT_FOOT.x);
    newRow.setFloat("y", LEFT_FOOT.y);
    newRow.setFloat("z", LEFT_FOOT.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_HIP");
    newRow.setFloat("x", RIGHT_HIP.x);
    newRow.setFloat("y", RIGHT_HIP.y);
    newRow.setFloat("z", RIGHT_HIP.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_KNEE");
    newRow.setFloat("x", RIGHT_KNEE.x);
    newRow.setFloat("y", RIGHT_KNEE.y);
    newRow.setFloat("z", RIGHT_KNEE.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_ANKLE");
    newRow.setFloat("x", RIGHT_ANKLE.x);
    newRow.setFloat("y", RIGHT_ANKLE.y);
    newRow.setFloat("z", RIGHT_ANKLE.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_FOOT");
    newRow.setFloat("x", RIGHT_FOOT.x);
    newRow.setFloat("y", RIGHT_FOOT.y);
    newRow.setFloat("z", RIGHT_FOOT.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "SPINE_SHOULDER");
    newRow.setFloat("x", SPINE_SHOULDER.x);
    newRow.setFloat("y", SPINE_SHOULDER.y);
    newRow.setFloat("z", SPINE_SHOULDER.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_HANDTIP");
    newRow.setFloat("x", LEFT_HANDTIP.x);
    newRow.setFloat("y", LEFT_HANDTIP.y);
    newRow.setFloat("z", LEFT_HANDTIP.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "LEFT_THUMB");
    newRow.setFloat("x", LEFT_THUMB.x);
    newRow.setFloat("y", LEFT_THUMB.y);
    newRow.setFloat("z", LEFT_THUMB.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_HANDTIP");
    newRow.setFloat("x", RIGHT_HANDTIP.x);
    newRow.setFloat("y", RIGHT_HANDTIP.y);
    newRow.setFloat("z", RIGHT_HANDTIP.z);
    newRow=table.addRow();
    newRow.setInt("time", tempTime);
    newRow.setInt("dancer", mUserId);
    newRow.setString("joint", "RIGHT_THUMB");
    newRow.setFloat("x", RIGHT_THUMB.x);
    newRow.setFloat("y", RIGHT_THUMB.y);
    newRow.setFloat("z", RIGHT_THUMB.z);
  }
}
