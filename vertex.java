
import java.io.*;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.orientechnologies.orient.core.tx.*; 
import com.orientechnologies.*; 
import com.orientechnologies.orient.core.db.graph.*;
import com.orientechnologies.orient.core.metadata.schema.OType;
import com.orientechnologies.orient.core.*;
import com.orientechnologies.orient.core.id.OClusterPosition;

class vertex
{

vertex (Object db) {

try{
	testprint("Start of vertex constructor!");

	graphdatabase database = (graphdatabase) db;

	vert = database.database.createVertex();

} catch (Exception e){
	testprint("vertex constructor!" + "Error: " + e.getMessage());

}
}



vertex (ODocument graphvertex) {
	vert = graphvertex;
}

ODocument vert;

void field_integer (String index, int value){
	vert.field (index, value);
}

void field_string (String index, String value){
	vert.field (index, value);
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
 i = (Integer) vert.field(index, OType.INTEGER);
} catch (Exception e){
	testprint("field_integer!" + "Error: " + e.getMessage());

}
return i.intValue();

}

String  get_field_string(String index){
	testprint("get_field_string! index: " + index);
return  (String) vert.field(index, OType.STRING);

}



void save (){
	testprint("save!");
	vert.save();
}


void delete (graphdatabase database){

	testprint("delete vertex!");
	database.database.removeVertex(vert );
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







