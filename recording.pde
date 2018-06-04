Table table; //this code allows you to record live Kinect data to hard drive for later playback - always make a new unique filename to avoid writing over existing data
String jointID,fileName="data/danceData3.csv"; //remember to set an unique filename if recording - if playing back this is where you identify the file you wish to playback (in a folder called data in the Kinect2UDP_Reciever folder)
float recordedX,recordedY,recordedZ,dancerID;
int recordedTime,rowCounter=0,numberOfRows;

void initialiseRecording() { //lets start the recording by formatting our data
  table=new Table();
  table.addColumn("time");
  table.addColumn("dancer");
  table.addColumn("joint");
  table.addColumn("x");
  table.addColumn("y");
  table.addColumn("z");
  println("recording Kinect data to RAM...");
}

void upDateRecorded() { //this is for reading and playing back data
  if(rowCounter<numberOfRows){  //iterate through the rows of the table
    recordedTime=table.getInt(rowCounter,0); //get the timestamp
    int currentTime=millis()-theTime;  //synch playback speed
    if(currentTime>=recordedTime) {
      for(int i=0;i<25;i++) { //iterate through the 25 joints of the skeleton
        recordedTime=table.getInt(rowCounter,0);
        dancerID=table.getInt(rowCounter,1); 
        jointID=table.getString(rowCounter,2); 
        recordedX=table.getFloat(rowCounter,3);
        recordedY=table.getFloat(rowCounter,4);
        recordedZ=table.getFloat(rowCounter,5);
        findRecordedSkeleton(); //put all the data together as a skeleton
        rowCounter++;
      }
    }
  } else { //if no users then delete them all
    user1.deleteUser();
    user2.deleteUser();
    user3.deleteUser();
    user4.deleteUser();
    user5.deleteUser();
    user6.deleteUser();
    rowCounter=0;
    theTime=millis();
  }
}

void findRecordedSkeleton() { //put the skeleton together
  User user=null;
  if(dancerID==1) user=user1;
  if(dancerID==2) user=user2;
  if(dancerID==3) user=user3;
  if(dancerID==4) user=user4;
  if(dancerID==5) user=user5;
  if(dancerID==6) user=user6;
  user.addJoint(jointID,new PVector(recordedX,recordedY,recordedZ)); //send the data to the user class to build the skeleton
  user.changeState(true);
}

void loadRecording() { //load a recording if playback is true
  println("loading recording...");
  table=loadTable(fileName, "header");
  numberOfRows=table.getRowCount();
  println(numberOfRows + " total rows in table");
}

void printRecorded() {
  for (TableRow row : table.rows()) {
    recordedTime=row.getInt("time");
    dancerID=row.getInt("dancer");
    jointID=row.getString("joint");
    recordedX=row.getFloat("x");
    recordedY=row.getFloat("y");
    recordedZ=row.getFloat("z");
    println("time " + recordedTime + " dancerID " + dancerID + " jointID " + jointID + " x " + recordedX + " y " + recordedY + " z " + recordedZ);
  }
}
