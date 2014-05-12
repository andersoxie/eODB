
import java.io.*;

import com.tinkerpop.blueprints.impls.orient.*;
import com.orientechnologies.orient.core.*; 


class vertex
{

vertex (Object db) {

try{
	testprint("Start of vertex constructor!");

	graphdatabase gdb = (graphdatabase ) db;

	vert = gdb.database.addVertex(null );
vert.setProperty("name", "Anders");
	testprint("End of vertex constructor!");

} catch (Exception e){
	testprint("vertex constructor!" + "Error: " + e.getMessage());

}
}



vertex (OrientVertex graphvertex) {
	vert = graphvertex;
}

OrientVertex vert;

void field_integer (String index, int value){
	vert.setProperty (index, value);
}

void field_string (String index, String value){
	vert.setProperty (index, value);
}


int get_cluster_id() {
//	testprint("vertex get_cluster_id!" + vert.getIdentity().getClusterId());

	return vert.getIdentity().getClusterId();

}
long get_cluster_position() {
//	testprint("vertex get_cluster_position!" + vert.getIdentity().getClusterPosition().longValueHigh());

	return vert.getIdentity().getClusterPosition().longValueHigh();

}



int  field_integer(String index){
Integer i = 0;
try{
 i = (Integer) vert.getProperty(index);
} catch (Exception e){
	testprint("field_integer!" + "Error: " + e.getMessage());

}
return i.intValue();

}

String  get_field_string(String index){
	testprint("get_field_string! index: " + index);
return  (String) vert.getProperty(index);

}



void save (){
	testprint("Do save!");
	vert.save();
	testprint("Saved!");
}


void delete (graphdatabase gdb){

	testprint("delete vertex!");
	gdb.database.removeVertex(vert );
//	vert.delete();
}



void testprint ( String text)
{
  try{
  // Create file 
  FileWriter fstream = new FileWriter("C:/Users/andersoxie/java_logging.txt", true);
  BufferedWriter out = new BufferedWriter(fstream);
  out.write(" " + text);
  out.newLine();
 //Close the output stream
  out.close();
  }catch (Exception e){//Catch exception if any
  System.err.println("Error: " + e.getMessage());

  }
}



}







