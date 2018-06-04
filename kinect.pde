void receive(byte[] data, String HOST_IP, int PORT_RX) { //receives data over ethernet from Kinect V2 connected to a Windows running the Kinect2UDP app
  if(!recorded) {
    String value=new String(data); //create something to hold the received data
    String[] vals=value.split(DELIMITER); //break the data up into its parts
    userID=int(vals[0]); //userID is the first part
    boolean skeletonState=boolean(vals[1]); //skeleton true/false is second part
    jointName=vals[2]; //name of joint
    jointType=int(vals[3]); //kind of joint
    skeletonColour=int(vals[7]); //colour of skeleton (useful for disambiguation)
    User user=null;
    if(userID==0) user=user1; //assign the userID
    if(userID==1) user=user2;
    if(userID==2) user=user3;
    if(userID==3) user=user4;
    if(userID==4) user=user5;
    if(userID==5) user=user6;
    if(!skeletonState) {
      if(user.myState){ //switch state if skeleton is true to false and delete skeleton
        user.changeState(false);
        user.deleteUser();
        println("deleted user " + user.mUserId);
      }
    } else { //else the skeleton is true so lets do something with it
      receivedJointPos.x=float(vals[4]); //extract position of joint
      receivedJointPos.y=float(vals[5]);
      receivedJointPos.z=float(vals[6]);
      transformCoordinates(); //transform coordinates to fit our world
      if(!user.myState){
        user.changeState(true); //lets turn on a user skeleton
        println("created user " + user.mUserId);
      }
      user.Colour=skeletonColour; //set its colour
      findSkeleton(user); //and put it all together
    }
  }
}

void transformCoordinates() { //transform coordinates to fit our world
  receivedJointPos.x=(receivedJointPos.x*udpScale)+400;
  receivedJointPos.y=(receivedJointPos.y*udpScale)+600;
  receivedJointPos.z=(receivedJointPos.z*udpScale)+1000;
}

void stop() { //close UDP when it is finished
  udp.close();
}

void findSkeleton(User user) { //add all the joints to the skeleton in the user class
  if(user!=null) {
    if(jointType==0) user.addJoint("SPINE_BASE",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==1) user.addJoint("SPINE_MID",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==2) user.addJoint("NECK",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==3) user.addJoint("HEAD",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==4) user.addJoint("LEFT_SHOULDER",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==5) user.addJoint("LEFT_ELBOW",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==6) user.addJoint("LEFT_WRIST",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==7) user.addJoint("LEFT_HAND",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==8) user.addJoint("RIGHT_SHOULDER",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==9) user.addJoint("RIGHT_ELBOW",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==10) user.addJoint("RIGHT_WRIST",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==11) user.addJoint("RIGHT_HAND",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==12) user.addJoint("LEFT_HIP",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==13) user.addJoint("LEFT_KNEE",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==14) user.addJoint("LEFT_ANKLE",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==15) user.addJoint("LEFT_FOOT",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==16) user.addJoint("RIGHT_HIP",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==17) user.addJoint("RIGHT_KNEE",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==18) user.addJoint("RIGHT_ANKLE",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==19) user.addJoint("RIGHT_FOOT",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==20) user.addJoint("SPINE_SHOULDER",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==21) user.addJoint("LEFT_HANDTIP",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==22) user.addJoint("LEFT_THUMB",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==23) user.addJoint("RIGHT_HANDTIP",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
    if(jointType==24) user.addJoint("RIGHT_THUMB",new PVector(receivedJointPos.x,receivedJointPos.y,receivedJointPos.z));
  }
}
