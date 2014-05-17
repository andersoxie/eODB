
import java.io.*;

import com.tinkerpop.blueprints.impls.orient.*;
import com.orientechnologies.orient.core.*; 

class edge
{

 edge (graphdatabase db, vertex v1, vertex v2, String label) {
	ed = db.database.addEdge(null, v1.vert, v2.vert, label);
}

 edge (OrientEdge graphedge) {
	ed = graphedge;
}


OrientEdge ed;

void field (String index, String value){
try{
	testprint("Start field! index: " + index + " Value: " + value);
	ed.setProperty (index, value);
	testprint("End field!");
} catch (Exception e){
	testprint("field!" + "Error: " + e.getMessage());
}
}

// TODO Might not need this feature
void set_label (String value){
try{
	testprint("set_label! Value: " + value);
// From 1.7 it is not possible to use "label" since that seems to be used internally
	ed.setProperty ("label_value", value);

} catch (Exception e){
	testprint("set_label!" + "Error: " + e.getMessage());
}
}



int get_cluster_id() {
	return ed.getIdentity().getClusterId();
}
long get_cluster_position() {
	return ed.getIdentity().getClusterPosition().longValueHigh();
}

void save (){
	testprint("Save edge!");
	ed.save();
	testprint("Edge saved!");
}

void delete (graphdatabase gdb){
try{
	testprint("Edge: delete!");
	gdb.database.removeEdge(ed );
} catch (Exception e){
	testprint("delete!" + "Error: " + e.getMessage());
}
}

// TODO 
//int fields(){
//	return ed.fields();
//}


public String  get_field_string(String index){
	testprint("get_field_string! index: " + index);
return  (String) ed.getProperty(index);

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