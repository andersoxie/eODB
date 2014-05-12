note
	description: "Summary description for {GRAPHDATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRAPHDATABASE

inherit
	SHARED_JNI_ENVIRONMENT

create
	make

feature -- Creation

	make (database_name : STRING)
		do
				--| Creation of the Java object
			java_graphdatabase_class := jni.find_class ("graphdatabase")
			my_database := database_name
		end


	change_database(database_name : STRING; user : STRING; pass : STRING)
		local

			j_args: JAVA_ARGS
		do
			if attached  java_graphdatabase_class as db_class then

				create j_args.make(3)
				j_args.put_string (database_name , 1)
				j_args.put_string (user , 2)
				j_args.put_string (pass , 3)

				create java_graphdatabase_object.create_instance (db_class, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", j_args)
			end
			if jni.exception_occurred then
				print ("Java exception occured in change_database!%N" )

				jni.exception_clear
			end

	end

	my_database : STRING

	open (user :STRING; pass : STRING)
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		change_database (my_database,user, pass)
		if attached java_graphdatabase_object as db_object then

--			create j_args.make(2)

--			fid := db_object.method_id ("open", "(Ljava/lang/String;Ljava/lang/String;)V")


--			db_object.void_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			else
				is_database_open := true
			end
		end
	end



	begin_optimistic_transition ()
	local
		fid: POINTER
	do
		if attached java_graphdatabase_object as db_object then

			fid := db_object.method_id ("begin_optimistic_transition", "()V")
			db_object.void_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
	jni.exception_clear
			end
		end
	end

	commit ()
	local
		fid: POINTER
	do
		if attached java_graphdatabase_object as db_object then
			fid := db_object.method_id ("commit", "()V")
			db_object.void_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
				jni.exception_clear
			end
		end
	end

	close ()
	require
		database_is_open : is_database_open

	local
		fid: POINTER
--		exec : EXECUTION_ENVIRONMENT
	do
		if attached java_graphdatabase_object as db_object then

			fid := db_object.method_id ("close", "()V")
			db_object.void_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			else
				is_database_open := false
			end
	--		jni.destroy_vm

	-- TODOLATER. To be evaluated if I still need some time to let the db close down. Maybe it was only the destruction of the vm that created problems.

	--		create exec
	--		-- Empreical value tested. Need to let the database to close down before we quit the application since otherwise the database files are corrupted.
	--		exec.sleep (5000000000)
		end
	end



	get_vertex (index :STRING; value : STRING) : detachable  VERTEX
	local
		j_args : JAVA_ARGS
		fid: POINTER
		v : detachable JAVA_OBJECT
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(2)
			j_args.put_string (index , 1)
			j_args.put_string (value , 2)

			fid := db_object.method_id ("get_vertex", "(Ljava/lang/String;Ljava/lang/String;)Lvertex;")
			v := db_object.object_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			elseif v /=void then
				Result := create {VERTEX}.make_from_java_object(Current, v)
			end
		end
	end


	get_out_edge (v :VERTEX; label : STRING) : detachable  EDGE
	local
		j_args : JAVA_ARGS
		fid: POINTER
		e : detachable JAVA_OBJECT
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(2)
			j_args.put_object (v.java_vertex_object , 1)
			j_args.put_string (label , 2)

			fid := db_object.method_id ("get_out_edge", "(Lvertex;Ljava/lang/String;)Ledge;")
			e := db_object.object_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			elseif e /=void then
				Result := create {EDGE}.make_from_java_object(Current, e)
			end
		end
	end

	get_in_edge (v :VERTEX; label : STRING) : detachable EDGE
	local
		j_args : JAVA_ARGS
		fid: POINTER
		e : detachable JAVA_OBJECT
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(2)
			j_args.put_object (v.java_vertex_object , 1)
			j_args.put_string (label , 2)

			fid := db_object.method_id ("get_in_edge", "(Lvertex;Ljava/lang/String;)Ledge;")
			e := db_object.object_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			elseif e /=void then
				Result := create {EDGE}.make_from_java_object(Current, e)
			end
		end
	end



	get_in_vertex (e :EDGE) : detachable VERTEX
	local
		j_args : JAVA_ARGS
		fid: POINTER
		v_result : detachable JAVA_OBJECT
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(1)
			j_args.put_object (e.java_edge_object , 1)

			fid := db_object.method_id ("get_in_vertex", "(Ledge;)Lvertex;")
			v_result := db_object.object_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			elseif v_result /=void then
				Result := create {VERTEX}.make_from_java_object(Current, v_result)
			end
		end
	end

	get_out_vertex (e :EDGE) : detachable VERTEX
	local
		j_args : JAVA_ARGS
		fid: POINTER
		v_result : detachable  JAVA_OBJECT
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(1)
			j_args.put_object (e.java_edge_object , 1)

			fid := db_object.method_id ("get_out_vertex", "(Ledge;)Lvertex;")
			v_result := db_object.object_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )

				jni.exception_clear
			elseif v_result /=void then
				Result := create {VERTEX}.make_from_java_object(Current, v_result)
			end
		end
	end

get_root_vertex () : detachable VERTEX
	local
		fid: POINTER
		v_result : detachable  JAVA_OBJECT
	do
		if attached java_graphdatabase_object as db_object then

			fid := db_object.method_id ("get_root_vertex", "()Lvertex;")
			v_result := db_object.object_method (fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
				jni.exception_clear
			elseif v_result /=void then
				Result := create {VERTEX}.make_from_java_object(Current, v_result)
			end
		end
	end

set_root_vertex (v : VERTEX)
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(1)
			j_args.put_object (v.java_vertex_object , 1)

			fid := db_object.method_id ("set_root_vertex", "(Lvertex;)V")
			db_object.void_method (fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
				jni.exception_clear
			end
		end
	end


	get_number_of_vertexes () : INTEGER_64
	local
		fid: POINTER
	do
		if attached java_graphdatabase_object as db_object then

			fid := db_object.method_id ("get_number_of_vertexes", "()J")
			Result := db_object.integer_method(fid, Void)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
				jni.exception_clear
				Result := 0
			end
		end
	end

	get_number_of_relations (v : VERTEX; label : STRING) : INTEGER_64
	local
		j_args : JAVA_ARGS
		fid: POINTER
	do
		if attached java_graphdatabase_object as db_object then

			create j_args.make(2)
			j_args.put_object (v.java_vertex_object , 1)
			j_args.put_string (label , 2)
			fid := db_object.method_id ("get_number_of_relations", "(Lvertex;Ljava/lang/String;)J")
			Result := db_object.integer_method(fid, j_args)
			if jni.exception_occurred then
				print ("Java exception occured!%N" )
				jni.exception_clear
				Result := 0
			end
		end
	end


	get_relations (v : VERTEX; label : STRING) : ARRAYED_LIST[EDGE]
	local
		j_args : JAVA_ARGS
		fid: POINTER
		edges : detachable  JAVA_OBJECT --_ARRAY
		array_of_edges : JAVA_OBJECT_ARRAY
		index : INTEGER
	do
		create Result.make (0)

		if attached java_graphdatabase_object as db_object then

			create j_args.make(2)
			j_args.put_object (v.java_vertex_object , 1)
			j_args.put_string (label , 2)

			fid := db_object.method_id ("get_relations", "(Lvertex;Ljava/lang/String;)[Ljava/lang/Object;")
			edges := db_object.object_method(fid, j_args)
	--		array_of_edges.
			if attached edges as ed then
				create array_of_edges.make_from_pointer (ed.java_object_id)
				if jni.exception_occurred then
					print ("Java exception occured!%N" )
					jni.exception_clear
				elseif array_of_edges /=void then
--					Create Result.make_filled(array_of_edges.count)
					Create Result.make(array_of_edges.count)
					from
						index := 1
					until
						index > array_of_edges.count
					loop
						if attached  array_of_edges.item (index-1) as e then
							-- FIXME. This was not attached so when index was incremetned within the if statemet it looped. But we need to investigate why it did not attach correct
--							Result[index] := create {EDGE}.make_from_java_object(Current, e)
							Result.extend ( create {EDGE}.make_from_java_object(Current, e))
						end
						index := index + 1
					end
				end
			end
		end
	end

	get_vertexes (id :STRING) :  ARRAYED_LIST[VERTEX]
	local
		j_args : JAVA_ARGS
		fid: POINTER
		vertexes : detachable  JAVA_OBJECT --_ARRAY
		array_of_vertexes : JAVA_OBJECT_ARRAY
		index : INTEGER
		temp : ARRAYED_LIST[VERTEX]
	do
		create Result.make(0)
		if attached java_graphdatabase_object as db_object then

			create j_args.make(1)
			j_args.put_string (id , 1)

			fid := db_object.method_id ("get_vertexes", "(Ljava/lang/String;)[Ljava/lang/Object;")
			vertexes := db_object.object_method(fid, j_args)
			if attached vertexes as vert then
				create array_of_vertexes.make_from_pointer (vert.java_object_id)
				if jni.exception_occurred then
					print ("Java exception occured!%N" )
					jni.exception_clear
				elseif array_of_vertexes /=void then
					create Result.make (array_of_vertexes.count)
--					Create Result.make_filled (array_of_vertexes.count)
					from
						index := 1
					until
						index > array_of_vertexes.count
					loop
						if attached array_of_vertexes.item (index-1)as e then
--							Result[index] := create {VERTEX}.make_from_java_object(Current, e )
--							 Result.array_put (create {VERTEX}.make_from_java_object(Current, e ), index)
							Result.extend (create {VERTEX}.make_from_java_object(Current, e ))
							index := index + 1
						end
					end
				end
			end
		end
	end




	is_database_open : BOOLEAN

feature {vertex, edge}

		java_graphdatabase_object: detachable JAVA_OBJECT
feature {NONE}
			java_graphdatabase_class: detachable JAVA_CLASS
end
