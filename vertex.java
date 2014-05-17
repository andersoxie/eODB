
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
try{
	testprint("Start field_integer in vertex! index: " + index + " Value: " + value);
	vert.removeProperty(index);
	vert.setProperty (index, value);
	testprint("End field_integer in vertex! Value set!");
   } catch (Exception e){
	testprint("field!" + "Error: " + e.getMessage());
   }
}

void field_string (String index, String value){
try{
	testprint("Start field_string in vertex! index: " + index + " Value: " + value);
	vert.setProperty (index, value);
	testprint("End field_string in vertex!");
   } catch (Exception e){
	testprint("field!" + "Error: " + e.getMessage());
   }
}


int get_cluster_id() {
	return vert.getIdentity().getClusterId();
}
long get_cluster_position() {
	return vert.getIdentity().getClusterPosition().longValueHigh();
}



int  field_integer(String index){
Integer i = 0;
try{
	testprint("field_integer! index: " + index);
	i = (Integer) vert.getProperty(index);
	testprint("field_integer! value: " + i.intValue());
} catch (Exception e){
	testprint("field_integer!" + "Error: " + e.getMessage());

}
return i.intValue();

}

String  get_field_string(String index){
String s;
s = "";
try{
	testprint("get_field_string! index: " + index);
	s = (String) vert.getProperty(index);
	testprint("get_field_string! value: " + s);
   } catch (Exception e){
	testprint("field!" + "Error: " + e.getMessage());
   }
	return s;
}



void save (){
	testprint("Do save!");
	vert.save();
	testprint("Saved!");
}


void delete (graphdatabase gdb){

	testprint("delete vertex!");
	gdb.database.removeVertex(vert );
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







