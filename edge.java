
import java.io.*;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.orientechnologies.orient.core.tx.*; 
import com.orientechnologies.*; 
import com.orientechnologies.orient.core.db.graph.*;
import com.orientechnologies.orient.core.metadata.schema.OType;
import com.orientechnologies.orient.core.id.OClusterPosition;

class edge
{

 edge (graphdatabase database, vertex v1, vertex v2) {
	ed = database.database.createEdge(v1.vert, v2.vert);
}

 edge (ODocument graphedge) {
	ed = graphedge;
}


ODocument ed;

void field (String index, String value){
	testprint("field! index: " + index + " Value: " + value);
	ed.field (index, value);
}

void set_label (String value){
try{
	testprint("set_label! Value: " + value);
	ed.field ("label", value);

} catch (Exception e){
	testprint("set_label!" + "Error: " + e.getMessage());
	//ed.delete();
}
}



int get_cluster_id() {
//	testprint("get_cluster_id!" + ed.getIdentity().getClusterId());

	return ed.getIdentity().getClusterId();

}
long get_cluster_position() {
//	testprint("get_cluster_position!" + ed.getIdentity().getClusterPosition().longValueHigh());

	return ed.getIdentity().getClusterPosition().longValueHigh();

}

void save (){
	testprint("save!");
	ed.save();
}

void delete (graphdatabase database){
try{
	testprint("Edge: delete!");
	database.database.removeEdge(ed );
} catch (Exception e){
	testprint("delete!" + "Error: " + e.getMessage());
	//ed.delete();
}
}


int fields(){
	return ed.fields();
}


public String  get_field_string(String index){
	testprint("get_field_string! index: " + index);
return  (String) ed.field(index, OType.STRING);

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