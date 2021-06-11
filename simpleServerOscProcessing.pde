/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
ArrayList<DataSender> senders = new ArrayList<DataSender>();

int PORT = 12345;
String textbuffer = "";

public class DataSender {
  int ID;
  float value;
   
  public DataSender(int ID_){
    ID = ID_;
  }
  
  void setValue(float v){
    value = v;
  }
  
  String type(){
    return "undefined";
  }
   
  void update(){
  
    OscMessage myMessage = new OscMessage("/"+type()+"/"+ID);
    myMessage.add(value); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
}


public class Winogradsky extends DataSender {
   
  public Winogradsky(int ID_){
    super(ID_);
  }
  
  String type(){
    return "winogradsky";
  }
  
  void update(){
    setValue(noise(frameCount));
    super.update();
  } 
}

public class Plant extends DataSender {
   
  public Plant(int ID_){
    super(ID_);
  }
  
  String type(){
    return "plant";
  }
  
  void update(){
    setValue(noise(frameCount));
    super.update();
  } 
}

public class GamePress extends DataSender {
   
  public GamePress(int ID_){
    super(ID_);
  }
  
  String type(){
    return "gamepress";
  }
  
  void update(){
    setValue(noise(frameCount));
    super.update();
  } 
}

void setup() {
  size(400,400);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,1);
  myRemoteLocation = new NetAddress("127.0.0.1",PORT);
  frameRate(30);
  
  for (int i = 0; i < 2; i++){
     senders.add(new Winogradsky(i));
  }
  
  for (int i = 0; i < 2; i++){
     senders.add(new Plant(i));
  }
  
  for (int i = 0; i < 1; i++){
     senders.add(new GamePress(i));
  }
}


void draw() {
  background(0);
  //OscMessage myMessage = new OscMessage("/sensor1");
  //myMessage.add(noise(frameCount)); /* add an int to the osc message */
  //oscP5.send(myMessage, myRemoteLocation); 
  
  for (int i = 0; i < senders.size(); i++){ 
         senders.get(i).update();        
    }
  
  
  textSize(15);
  text(textbuffer, 10, 30);
  
  
}
