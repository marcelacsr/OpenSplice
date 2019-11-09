package br.pucrio.inf.lac.helloworld;

import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.opencsv.CSVUtilExample;
import com.opencsv.CSVUtils;
import com.opencsv.CSVWriter;

import lac.cnclib.sddl.message.ApplicationMessage;
import lac.cnclib.sddl.serialization.Serialization;
import lac.cnet.sddl.objects.ApplicationObject;
import lac.cnet.sddl.objects.Message;
import lac.cnet.sddl.objects.PrivateMessage;
import lac.cnet.sddl.udi.core.SddlLayer;
import lac.cnet.sddl.udi.core.UniversalDDSLayerFactory;
import lac.cnet.sddl.udi.core.listener.UDIDataReaderListener;

public class HelloCoreServer implements UDIDataReaderListener<ApplicationObject> {
  SddlLayer  core;
  int        counter;

  public static void main(String[] args) {
    Logger.getLogger("").setLevel(Level.OFF);

    new HelloCoreServer();
  }

  public HelloCoreServer() {
    core = UniversalDDSLayerFactory.getInstance();
    core.createParticipant(UniversalDDSLayerFactory.CNET_DOMAIN);

    core.createPublisher();
    core.createSubscriber();

    Object receiveMessageTopic = core.createTopic(Message.class, Message.class.getSimpleName());
    core.createDataReader(this, receiveMessageTopic);

    Object toMobileNodeTopic = core.createTopic(PrivateMessage.class, PrivateMessage.class.getSimpleName());
    core.createDataWriter(toMobileNodeTopic);

    counter = 0;
    System.out.println("=== Server Started (Listening) ===");
    synchronized (this) {
      try {
        this.wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }

  @Override
  public void onNewData(ApplicationObject topicSample) {
    Message message = (Message) topicSample;
    System.out.println("Server - vai receber e escrever a mensagem enviada pelo cliente");
    System.out.println(Serialization.fromJavaByteStream(message.getContent()));
        
    ArrayList<String> linha = (ArrayList<String>) Serialization.fromJavaByteStream(message.getContent());
   
    try {
		CSVWriterExample(linha);
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    
   //ArrayList<String> serializableContent = ; 
   // String csvFile = "C:/Users/Erica/Documents/smartfallGeradoServer.csv";
   //FileWriter writer = new FileWriter(csvFile);
   //writeline
    
    System.out.println("Server - mensagem recebida do cliente e escrita no server");
    PrivateMessage privateMessage = new PrivateMessage();
    privateMessage.setGatewayId(message.getGatewayId());
    privateMessage.setNodeId(message.getSenderId());

    synchronized (core) {
      counter++;
    }
    
    ApplicationMessage appMsg = new ApplicationMessage();
    appMsg.setContentObject(counter);
    privateMessage.setMessage(Serialization.toProtocolMessage(appMsg));

    core.writeTopic(PrivateMessage.class.getSimpleName(), privateMessage);
  }
  
  public static void CSVWriterExample(ArrayList<String> arg) throws IOException {
  
	  String csvFile = "C:/OpenSplice/HDE/x86_64.win64/smartfallGeradoServer2.csv";	 	
	  System.out.println(arg);
	  
	  
	  try {
		  
		// create FileWriter object with file as parameter 
	      FileWriter outputfile = new FileWriter(csvFile); 

	   // create CSVWriter object writer object as parameter 
	      CSVWriter writer = new CSVWriter(outputfile); 
	      
	   // create a List which contains String array 
	      List<String[]> data = new ArrayList<String[]>();
      
	   // declaration and initialize String Array 
	      String[] str = new String[arg.size()]; 
	     
	      ArrayList<String[]> list = new ArrayList<String[]>();
	      
	      StringBuilder sb = new StringBuilder();
	      
	      System.out.print("Imprimir cada registro recebido na lista de array: \n");
	   // ArrayList to Array Conversion 
	        for (int j = 0; j < arg.size(); j++) { 
	        	        	      	
	        	// Assign each value to String array 
	            str[j] = arg.get(j); 
	            //list.add(j, str);
	                     
	            writer.writeNext(str);
	            
	            System.out.print("linha"+str[j]+"\n");
	         
		        
	        } 
            
	        System.out.print("\n\n String Array[]: " + Arrays.toString(str));
	       	         	
	        System.out.println("\n Escrevi no csv");
	        
	        writer.flush();
            writer.close();
	        
	  }
      catch (Exception e) {
          System.out.println("Error in CsvFileWriter.");
          e.printStackTrace();
      } 
}
}