note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	VERTEX_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events
--tracing_setting : TRACING_SETTING
--TRACEING_HANDLER : TRACE_TO_FILE_HANDLER
	on_prepare
			-- <Precursor>
		local
			dbm : DATABASEMANAGEMENT
		do
			create dbm.make
			dbm.create_test_database (Current)

			create test_db.make("local:"+ dbm.test_folder_name)
			if attached test_db as db then
				db.open ("admin", "admin")
				assert ("Is open", db.is_database_open)
			else
				assert("Could not contact test db", false)
			end

--			create tracing_setting
--			tracing_setting.enable_tracing
--			create traceing_handler
--			traceing_handler.activate

		end


	on_clean
			-- <Precursor>
		do
			if attached test_db as db  then
				db.close
				assert ("Is closed", not db.is_database_open)
			else
				assert ("Is closed", false)
			end


--			traceing_handler.deactivate
--			traceing_handler.close_log_file
--			tracing_setting.disable_tracing
--			traceing_handler.close_trace_db

		end

feature -- Test routines

	create_vertex
			-- Only create it. Do not save it. Now I save automatically when creating so I had to change this test case
		local
			vert : VERTEX
		do
			if attached test_db as db  then
				create vert.make (db)
				assert ("Vertex removed", db.get_number_of_vertexes = 1)
			else
				assert("Could not contact test db", false)
			end
		end


	delete_vertex
			--
		local
			vert : VERTEX
		do
			if attached test_db as db  then
				create vert.make (db)
				vert.save
				assert ("Vertex stored", db.get_number_of_vertexes = 1)
				vert.delete
				assert ("Vertex removed", db.get_number_of_vertexes = 0)
			else
				assert("Could not contact test db", false)
			end
		end

	set_integer_value_in_vertex
			--
		local
			vert : VERTEX
		do
			if attached test_db as db  then

				create vert.make (db)
				vert.field_integer ("First", 123)
				vert.save
				assert ("Vertex stored", db.get_number_of_vertexes = 1)
				assert ("Value set", vert.get_field_integer ("First") = 123 )
				vert.delete
				assert ("Vertex removed", db.get_number_of_vertexes = 0)
			else
				assert("Could not contact test db", false)
			end
		end


	set_string_value_in_vertex
			--
		local
			vert : VERTEX
		do
			if attached test_db as db  then
				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_string ("StringFirst", "First string")
				vert.save
				db.commit
				assert ("Vertex stored", db.get_number_of_vertexes = 1)
				assert ("Value set", vert.get_field_string ("StringFirst").is_equal ("First string") )
				vert.delete
				assert ("Vertex removed", db.get_number_of_vertexes = 0)
			else
				assert("Could not contact test db", false)
			end
		end



	change_value_in_vertex
			--
		local
			vert : VERTEX
		do
			if attached test_db as db  then

				create vert.make (db)
				vert.field_integer ("First", 1)
				vert.save
				assert ("Value stored", db.get_number_of_vertexes = 1)
				assert ("Second value set", vert.get_field_integer ("First") = 1 )
				vert.field_integer ("First", 8)
				vert.save
				assert ("Value stored", db.get_number_of_vertexes = 1)
				assert ("Second value set", vert.get_field_integer ("First") = 8 )
				vert.delete
				assert ("Vertex removed", db.get_number_of_vertexes = 0)
			else
				assert("Could not contact test db", false)
			end
		end

	change_value_in_vertex_with_transactions
			--
		local
			vert : VERTEX
		do
			if attached test_db as db  then
				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_integer ("First", 1)
				vert.save
				db.commit
				assert ("Value stored", db.get_number_of_vertexes = 1)
				assert ("Second value set", vert.get_field_integer ("First") = 1 )
				db.begin_optimistic_transition
				vert.field_integer ("First", 8)
				vert.save
				db.commit
				assert ("Value stored", db.get_number_of_vertexes = 1)
				assert ("Second value set", vert.get_field_integer ("First") = 8 )
				db.begin_optimistic_transition
				vert.delete
				db.commit
				assert ("Vertex removed", db.get_number_of_vertexes = 0)
			else
				assert("Could not contact test db", false)
			end
		end

	change_value_in_vertex_with_only_one_transactions
			--
		local
			vert : VERTEX
		do
			if attached test_db as db  then
				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_integer ("First", 1)
				vert.save
				assert ("First value stored. Number of vertexies was: " + db.get_number_of_vertexes.out, db.get_number_of_vertexes = 0) -- It is zero since ae have not yet commited the data to the database
				assert ("Second value set", vert.get_field_integer ("First") = 1 )
				vert.field_integer ("First", 8)
				vert.save
				assert ("Second value stored", db.get_number_of_vertexes = 0)-- It is zero since ae have not yet commited the data to the database
				assert ("Second value set", vert.get_field_integer ("First") = 8 )
				vert.delete
				db.commit
				assert ("Vertex removed", db.get_number_of_vertexes = 0)
			else
				assert("Could not contact test db", false)
			end
		end



	change_value_in_vertex_without_saving
			-- This to try to understand when I communicate with the database and when it is saved etc. Seems to be an automatic rollback in this case.
			-- 2013-05-16 Since I now automaticallysave when creating this case needed some changes. Might not be interesgted to keep.
		local
			vert : VERTEX
		do
			if attached test_db as db  then

				create vert.make (db)
				vert.field_integer ("First", 1)
				assert ("Value not stored but still exists", db.get_number_of_vertexes = 1)
				assert ("First value set", vert.get_field_integer ("First") = 1 )
				vert.field_integer ("First", 8)
				assert ("Second value set", vert.get_field_integer ("First") = 8 )
				assert ("Vertex auto saved", db.get_number_of_vertexes = 1)
			else
				assert("Could not contact test db", false)
			end
		end

	get_cluster_id
		local
			vert : VERTEX
		do
			if attached test_db as db  then

				create vert.make (db)
				vert.save
				assert ("Has cluster id", vert.get_cluster_id > 0)
			else
				assert("Could not contact test db", false)
			end
		end


	get_cluster_id_With_transaction
		local
			vert : VERTEX
		do
			if attached test_db as db  then

				db.begin_optimistic_transition
				create vert.make (db)
				vert.save
				db.commit
				assert ("Has cluster id", vert.get_cluster_id > 0)
			else
				assert("Could not contact test db", false)
			end
		end

	get_cluster_id_if_not_saving_I_get_miunus_one
		local
			vert : VERTEX
		do
			if attached test_db as db  then

				create vert.make (db)
				assert ("Has cluster id", vert.get_cluster_id > -1) -- Since I now automatically save the vertex it will get a cluster id greater than 1
			else
				assert("Could not contact test db", false)
			end
		end

	get_cluster_position
	local
		vert2 : VERTEX
			vert : VERTEX
		do
			if attached test_db as db  then

				create vert.make (db)
				vert.save
				assert ("First has cluster position", vert.get_cluster_position >= 0)
				create vert2.make (db)
				vert2.save
				assert ("Second has cluster position", vert2.get_cluster_position > 0)
			else
				assert("Could not contact test db", false)
			end
		end

feature {NONE}

	test_db: detachable GRAPHDATABASE

end


