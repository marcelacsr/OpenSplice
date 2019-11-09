package br.pucrio.inf.lac.helloworld;

import java.io.FileReader;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;

import lac.cnclib.net.NodeConnection;
import lac.cnclib.net.NodeConnectionListener;
import lac.cnclib.net.mrudp.MrUdpNodeConnection;
import lac.cnclib.sddl.message.ApplicationMessage;
import lac.cnclib.sddl.message.Message;


public class HelloCoreClient implements NodeConnectionListener {

  private static String		gatewayIP   = "127.0.0.1";
  private static int		gatewayPort = 5500;
  private MrUdpNodeConnection	connection;

  public static void main(String[] args) {
      Logger.getLogger("").setLevel(Level.OFF);
      new HelloCoreClient();
  }

  public HelloCoreClient() {
      InetSocketAddress address = new InetSocketAddress(gatewayIP, gatewayPort);
      try {
          connection = new MrUdpNodeConnection();
          connection.addNodeConnectionListener(this);
          connection.connect(address);
      } catch (IOException e) {
          e.printStackTrace();
      }
  }

  @Override
  public void connected(NodeConnection remoteCon) {
      ApplicationMessage message = new ApplicationMessage();
      
      //CSVReaderExample();
      //System.out.println(CSVReaderExample());
      //String serializableContent = "Hello World Erica!!";
      ArrayList<String> serializableContent = CSVReaderExample(); // acessa a função, imprime o conteúdo dela e retorna o line2
      message.setContentObject(serializableContent); 
      System.out.println(message);

      try {
          connection.sendMessage(message);
      } catch (IOException e) {
          e.printStackTrace();
      }
      
                 
  }

  
  
  private ArrayList<String> CSVReaderExample() {
	// TODO Auto-generated method stub
	  String csvFile = "C:/Users/Erica/Documents/smartfall.csv";
      
	  String line2 = null;
      CSVReader reader = null;
      ArrayList<String> avisos = new  ArrayList<String>(); 
      try {
          reader = new CSVReaderBuilder(new FileReader(csvFile)).withSkipLines(1).build();
          String[] line;
          while ((line = reader.readNext()) != null) {
              System.out.println("Reg [Ax= " + line[0] + ", Ay= " + line[1] + " , Az=" + line[2] + " , fall=" + line[3] + "]");
              line2 = "Reg [Ax= " + line[0] + ", Ay= " + line[1] + " , Az=" + line[2] + " , fall=" + line[3] + "]";
              avisos.add(line2);
              //System.out.println(line2);
          }
          System.out.println(avisos);
          
      } catch (IOException e) {
          e.printStackTrace();
      }
     
	// return line2;
      return avisos;

}

@Override
  public void newMessageReceived(NodeConnection remoteCon, Message message) {
      System.out.println(message.getContentObject());
	  System.out.println("Client - Recebe o contador de sincronização do Server");
  }
    
  // other methods

  @Override
  public void reconnected(NodeConnection remoteCon, SocketAddress endPoint, boolean wasHandover, boolean wasMandatory) {}

  @Override
  public void disconnected(NodeConnection remoteCon) {}

  @Override
  public void unsentMessages(NodeConnection remoteCon, List<Message> unsentMessages) {}

  @Override
  public void internalException(NodeConnection remoteCon, Exception e) {}
}


