note
	description: "Summary description for {VERTEX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VERTEX

INHERIT
	SHARED_JNI_ENVIRONMENT

create
   make

create    {GRAPHDATABASE} make_from_java_object
feature

	make(DB : GRAPHDATABASE)
	require
		is_open : db.is_database_open
	local
		java_vertex_class: detachable JAVA_CLASS
		j_args: JAVA_ARGS
	do
		database := db
			--| Creation of the Java object
		java_vertex_class := jni.find_class ("vertex")
		if java_vertex_class /= Void then

			create j_args.make(1)
			j_args.put_object (database.java_graphdatabase_object,1)

			create java_vertex_object.create_instance (java_vertex_class, "(Ljava/lang/Object;)V", j_args)
save()
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			end
		end

	end




	field_string (index :STRING; value : STRING)
	-- TODO Does not seem to be allowed with spaces in the index string
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		if attached java_vertex_object as ver_obj then
			create j_args.make(2)
			j_args.put_string (index , 1)
			j_args.put_string (value , 2)

			fid := ver_obj.method_id ("field_string", "(Ljava/lang/String;Ljava/lang/String;)V")

			ver_obj.void_method (fid, j_args)

			save()

			if jni.exception_occurred then
				print ("Java exception occured in field_string!%N" )

				jni.exception_clear
			end
		end
	ensure
		value_set : get_field_string(index).is_equal (value)
	end

	field_integer (index :STRING; value : INTEGER)
	-- TODO Does not seem to be allowed with spaces in the index string
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		if attached java_vertex_object as ver_obj then
			create j_args.make(2)
			j_args.put_string (index , 1)
			j_args.put_int (value , 2)

			fid := ver_obj.method_id ("field_integer", "(Ljava/lang/String;I)V")

			ver_obj.void_method (fid, j_args)

			save()

			if jni.exception_occurred then
				print ("Java exception occured in field integer!%N" )

				jni.exception_clear
			end
		end
	ensure
		value_set : get_field_integer (index).is_equal (value)
	end




	get_field_integer ( index : STRING) : INTEGER
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		if attached java_vertex_object as ver_obj then

			create j_args.make(1)
			j_args.put_string (index , 1)
			fid := ver_obj.method_id ("field_integer", "(Ljava/lang/String;)I")

			Result := ver_obj.integer_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured in get_fieled_integer!%N" )

				jni.exception_clear
			end
		end
	end


	get_field_string ( index : STRING) : STRING
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		Result := ""
		if attached java_vertex_object as ver_obj then

			create j_args.make(1)
			j_args.put_string (index , 1)
			fid := ver_obj.method_id ("get_field_string", "(Ljava/lang/String;)Ljava/lang/String;")

			if attached ver_obj.string_method (fid, j_args) as res then
				Result := res
			end
			if jni.exception_occurred then
				print ("Java exception occured get_field_string!%N" )

				jni.exception_clear
			end
		end
	end

	get_cluster_id () : INTEGER
	local
		fid: POINTER
--	once ("OBJECT") Not possible to have once objects since when the java object is not saved it returns -1 and after that it will get a correct id.
	do -- TODO One possible solution is to have two lists in the TASK_FACTORY class. One with saved TASKs and one with not saved TASKs. When a TASKs save feature is called
	   -- the it publish tahat it is saved and the TASK_FACTORY has then earlier subsribed to that event and can then moce the TASK from the none-saved list to the saved list.
   		if attached java_vertex_object as ver_obj then

			fid := ver_obj.method_id ("get_cluster_id", "()I")

			Result := ver_obj.integer_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured in get_cluster_id!%N" )
				jni.exception_clear
			end
		end
	end

	get_cluster_position : INTEGER_64
	local
		fid: POINTER
--	once ("OBJECT") Not possible to have once objects since when the java object is not saved it returns -1 and after that it will get a correct id.
	do
		if attached java_vertex_object as ver_obj then

			fid := ver_obj.method_id ("get_cluster_position", "()J")

			if fid.is_default_pointer then
				Result:=0
			else
				Result := ver_obj.integer_method (fid, Void)
			end

			if jni.exception_occurred then
				print ("Java exception occured get_cluster_position!%N" )
				jni.exception_clear
			end
		end
	end

	save ()
	local
		fid: POINTER
	do
		if attached java_vertex_object as ver_obj then

			fid := ver_obj.method_id ("save", "()V")
			ver_obj.void_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			end
		end
	end

	delete ()
	local
		j_args: JAVA_ARGS
		fid: POINTER
	do
		if attached java_vertex_object as ver_obj then

			create j_args.make(1)
			j_args.put_object (database.java_graphdatabase_object,1)

			fid := ver_obj.method_id ("delete", "(Lgraphdatabase;)V")
			ver_obj.void_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
				jni.exception_clear
			end
		end
	end


	database : GRAPHDATABASE
	feature {EDGE, GRAPHDATABASE}

	make_from_java_object (db : GRAPHDATABASE; j_vertex : JAVA_OBJECT)
	do
		database := db
		java_vertex_object := j_vertex;
	end


	feature {EDGE, GRAPHDATABASE}
	java_vertex_object : detachable JAVA_OBJECT


end
