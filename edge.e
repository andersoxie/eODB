note
	description: "Summary description for {EDGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EDGE

inherit
	SHARED_JNI_ENVIRONMENT

create
   make

create    {GRAPHDATABASE} make_from_java_object

feature

	make(DB : GRAPHDATABASE; v1 : VERTEX; v2 : VERTEX)
	local
		java_edge_class: detachable JAVA_CLASS
		j_args: JAVA_ARGS
	do
		database := db
			--| Creation of the Java object
		java_edge_class := jni.find_class ("edge")
		if java_edge_class /= Void then

			create j_args.make(3)
			j_args.put_object (database.java_graphdatabase_object,1)
			j_args.put_object (v1.java_vertex_object,2)
			j_args.put_object (v2.java_vertex_object,3)

			create java_edge_object.create_instance (java_edge_class, "(Lgraphdatabase;Lvertex;Lvertex;)V", j_args)

			save()
			v1.save
			v2.save

			if jni.exception_occurred then
				print ("Java exception occured EDGE make!%N" )

				jni.exception_clear
			end
		end

	end




	save ()
	local
		fid: POINTER
	do
		if attached java_edge_object as java_edge then
			fid := java_edge.method_id ("save", "()V")
			java_edge.void_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured in EDGE save!%N" )
				jni.exception_clear
			end
		end
	end

	delete ()
	local
		j_args: JAVA_ARGS
		fid: POINTER
	do
		if attached java_edge_object as java_edge then

			create j_args.make(1)
			j_args.put_object (database.java_graphdatabase_object,1)


			fid := java_edge.method_id ("delete", "(Lgraphdatabase;)V")
			java_edge.void_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured in EDGE delete!%N" )
				jni.exception_clear
			end
		end
	end

	field_string (index :STRING; value : STRING)
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		if attached java_edge_object as java_edge then

			create j_args.make(2)
			j_args.put_string (index , 1)
			j_args.put_string (value , 2)

			fid := java_edge.method_id ("field", "(Ljava/lang/String;Ljava/lang/String;)V")

			java_edge.void_method (fid, j_args)

			save()

			if jni.exception_occurred then
				print ("Java exception occured in EDGE field_string!%N" )

				jni.exception_clear
	-- TODOLATER Through a developer exception
			end
		end

	end

	get_field_string ( index : STRING) : STRING
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		Result := ""
		if attached java_edge_object as java_edge then

			create j_args.make(1)
			j_args.put_string (index , 1)
			fid := java_edge.method_id ("get_field_string", "(Ljava/lang/String;)Ljava/lang/String;")
			Result := ""
			if attached java_edge.string_method (fid, j_args) as res then
				Result := res
			end
			if jni.exception_occurred then
				print ("Java exception occured in EDGE get_field_string!%N" )

				jni.exception_clear
			end
		end
	end

	database : GRAPHDATABASE

feature {GRAPHDATABASE}

	make_from_java_object (db : GRAPHDATABASE;   j_edge : JAVA_OBJECT)
	do
		database := db
		java_edge_object := j_edge;
	end


feature {GRAPHDATABASE}
	java_edge_object : detachable JAVA_OBJECT


end
