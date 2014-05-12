import java.io.*;
import java.util.Iterator;

import com.tinkerpop.blueprints.impls.orient.*;
import com.orientechnologies.orient.core.*; 

import com.tinkerpop.blueprints.Graph;
import com.tinkerpop.blueprints.Vertex;
import com.tinkerpop.blueprints.Edge;
import com.tinkerpop.blueprints.Direction;



class graphdatabase
{

 graphdatabase (String database_name, String user, String pass ) {

try{
	testprint("Start of graphdatabase constructor!");
//	database = new OGraphDatabase( database_name);

	database = new OrientGraph( database_name, user, pass);
	testprint("End of graphdatabase constructor!");

} catch (Exception e){
	testprint("graphdatabase constructor!" + "Error: " + e.getMessage());
}
}

public OrientGraph database;


//OGraphDatabase database = OGraphDatabasePool.global().acquire("remote:localhost/temp", "writer", "writer");

void open (String user, String pass){
	testprint("graphdatabase open!");

try{
	testprint("graphdatabase open! user =" + user + ".Password =" + pass );
//	database.open (user, pass);
} catch (Exception e){
	testprint("Exception in graphdatabase open! user =" + user + ".Password =" + pass + ".Error: " + e.getMessage());
}
}


void commit (){
try {
	testprint("graphdatabase Commit!");
	database.commit();
} catch (Exception e){
	testprint("graphdatabase commit! " + "Error: " + e.getMessage());
}
}

void close (){
try {
	testprint("graphdatabase close!");
	database.shutdown();
} catch (Exception e){
	testprint("graphdatabase close! " + "Error: " + e.getMessage());
}
}

//TODO Seems that it will always start an optimistic transitin by default.
void begin_optimistic_transition (){
try {
	testprint("graphdatabase begin optimistic transition!");
	//database.begin(OTransaction.TXTYPE.OPTIMISTIC);
} catch (Exception e){
	testprint("graphdatabase begin optimisitc transition! " + "Error: " + e.getMessage());
}
}


vertex get_vertex (String index, String value){
	OrientVertex res_vert = null;
try {
	testprint("graphdatabase get_vertex, Index : " + index + " Value: " + value);
	Iterable<Vertex> iter =  database.getVertices();
	Iterator i = iter.iterator(); 
	OrientVertex vert;	
	String vertex_value;	
	while ( i.hasNext()) {
		testprint("Iterating Vertices! ");
		vert = (OrientVertex) i.next();
		vertex_value = (String) vert.getProperty(index);
		if (vertex_value != null)  {
			if ( vertex_value.compareTo(value) == 0) {
				testprint("Iterating Vertices! " + vertex_value);
				res_vert = vert;
			}
		}
	}
} catch (Exception e){
	testprint("graphdatabase get_vertex! " + "Error: " + e.getMessage());
}
if (res_vert != null) {
	return new vertex (res_vert);
}
return null;
}


edge get_out_edge( vertex v, String label){
	testprint("graphdatabase get_out_edge, label : " + label);

//What should the label be. Now I use same as when creating in edge.java
	Iterable <Edge> edges = v.vert.getEdges(Direction.OUT , "bsharp_edge");
	OrientEdge e;
	edge edge_to_return = null;
	Iterator i = edges.iterator(); 
	while ( i.hasNext()) {
		e = (OrientEdge) i.next();
		edge_to_return = new edge(e);
	}
	return edge_to_return;

}

edge get_in_edge( vertex v, String label){
	testprint("graphdatabase get_in_edge, label : " + label);

	Iterable <Edge> s = v.vert.getEdges(Direction.IN, "bsharp_edge");
	OrientEdge e;
	edge edge_to_return = null;
	Iterator i = s.iterator(); 
	while ( i.hasNext()) {
		e = (OrientEdge) i.next();
		edge_to_return = new edge(e);
	}
	return edge_to_return;
}

void set_root_vertex( vertex v){
//	database.setRoot ("graph", v.vert);  TODO
}

vertex get_root_vertex(){
//	return new vertex (database.getRoot ("graph"));TODO
	return new vertex (null);

}



vertex get_out_vertex( edge e){
	testprint("Get_out_vertex");
// Changed from getoutvertex
	return new vertex (database.getVertex(e.ed));
}


vertex get_in_vertex( edge e){
	testprint("Get_in_vertex");
// chenged from getinvertex
	return new vertex (database.getVertex(e.ed));
}



long get_number_of_vertexes (){
try {
	testprint("graphdatabase get_number_of_verticies! Was: "+ database.countVertices());
	
	return database.countVertices();
} catch (Exception e){
	testprint("graphdatabase get_number_of_vertexes! " + "Error: " + e.getMessage());
}
return 0;

}

long get_number_of_relations (vertex v,  String label){
OrientEdge ed;

try {
	testprint("graphdatabase get_number_of_relations, label : " + label);
	testprint("graphdatabase get_number_of_relations!");
	Iterable <Edge> s = v.vert.getEdges(Direction.OUT);
	Iterator j = s.iterator();

	int index = 0;
	while ( j.hasNext()) {
		ed = (OrientEdge) j.next();
		index++;
	}
	
//	edge_array = s.toArray();
	testprint("graphdatabase get_number_of_relations, number : " + index);
	return index;

} catch (Exception e){
	testprint("graphdatabase get_number_of_relations! " + "Error: " + e.getMessage());
}
return 0;
}

Object[] get_relations(vertex v,  String label){

Object[] array_of_edges;
OrientEdge e;

try {
	testprint("graphdatabase get_relations! label: " +  label);
//	Iterable <Edge> s = v.vert.getEdges(Direction.OUT, "bsharp_edge");
	Iterable <Edge> s = v.vert.getEdges(Direction.OUT);
	
//	array_of_edges = new Object[s.size()];

	Iterator j = s.iterator();
	int index = 0;
	while ( j.hasNext()) {
		e = (OrientEdge) j.next();
		index++;
	}
	array_of_edges = new Object[index];

	
	index = 0;
	Iterator i = s.iterator(); 
	while ( i.hasNext()) {
		e = (OrientEdge) i.next();
		 array_of_edges[index] = new edge(e);
		index++;
	}
	testprint("graphdatabase got " + index + " relations for label : " + label);


	return array_of_edges;

} catch (Exception exc){
	testprint("graphdatabase get_relations! " + "Error: " + exc.getMessage());
}
return null;
}


Object[] get_vertexes (String index){
	OrientVertex res_vert = null;

int number_of_vertexes;

Object[] array_of_vertexes;

try {
	testprint("graphdatabase get_vertexes! index: " + index );
	number_of_vertexes = 0;


	Iterable<Vertex> iter = database.getVertices();
	Iterator i = iter.iterator(); 
	OrientVertex vert;	
	String vertex_value;	
	while ( i.hasNext()) {
		testprint("Iterating Vertices! ");
		vert = (OrientVertex) i.next();
		vertex_value = (String) vert.getProperty(index);
		if (vertex_value != null)  {
				number_of_vertexes++;
		}
	}

	array_of_vertexes = new Object[number_of_vertexes];


	Iterable<Vertex> iter2 = database.getVertices();

	i = iter2.iterator(); 

	int ind = 0;
	while ( i.hasNext()) {
		testprint("Iterating Vertices! Again");
		vert = (OrientVertex) i.next();
		vertex_value = (String) vert.getProperty(index);
		if (vertex_value != null)  {
			testprint("Iterating Vertices! Found one that matched");
			array_of_vertexes[ind] = new vertex(vert );
			ind++;
		}

	testprint("Returning an array with " + ind +" vertexes");
	}
	return array_of_vertexes;
} catch (Exception e){
	testprint("graphdatabase get_vertexes! " + "Error: " + e.getMessage());
}
if (res_vert != null) {
	return new Object[0];
}
return new Object[0];
}


Object[] edge_array;

void testprint ( String text)
{
  try{
//   Create file 
  FileWriter fstream = new FileWriter("C:/Users/andersoxie/java_logging.txt", true);
  BufferedWriter out = new BufferedWriter(fstream);
  out.write(text);
  out.newLine();
 // Close the output stream
  out.close();
  }catch (Exception e){//Catch exception if any
 System.err.println("Error: " + e.getMessage());

  }
}


}