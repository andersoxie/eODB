note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	GRAPHDATABASE_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events
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
				assert ("Is empty", db.get_number_of_vertexes = 0)
			else
				assert("Was not able to create database", false)
			end
		end

	on_clean
			-- <Precursor>
		do
			if attached test_db as db then
				assert ("Is empty, vertexes", db.get_number_of_vertexes = 0)
				db.close
				assert ("Is closed", not db.is_database_open)
			else
				assert("Could not contact test db", false)
			end
		end

feature

	open_and_close
			-- New test routine
		do
			-- Everything done in on_prepare and on_clean, but I kepp it so that I know that on_prepare and on_clean works.
		end


	simpel_empty_transaction
			-- New test routine
		do
			if attached test_db as db then
				db.begin_optimistic_transition
				db.commit
			else
				assert("Could not contact test db", false)
			end
		end

	number_of_vertexes
			--
		local
			vert : VERTEX
		do
			if attached test_db as db then
				db.begin_optimistic_transition
				create vert.make (db)
				vert.save
				db.commit
				assert ("Is not empty", db.get_number_of_vertexes = 1)
				vert.delete
				db.commit
			else
				assert("Could not contact test db", false)
			end
		end

	get_vertexes_simple
			--
		local
			vert : VERTEX
			list_of_vertexes : LIST[VERTEX]
		do
			if attached test_db as db then
				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_string ("teststring", "testvalue1")
				vert.save
				db.commit
				assert ("Is not empty", db.get_number_of_vertexes = 1)
				list_of_vertexes := db.get_vertexes ("teststring")
				assert ("Is not empty", list_of_vertexes.count = 1)
				list_of_vertexes := db.get_vertexes ("wrong label")
				assert ("Is not empty", list_of_vertexes.count = 0)
				vert.delete
				db.commit
			else
				assert("Could not contact test db", false)
			end
		end


	get_vertexes_advanced
			--
		local
			vert, vert2, vert3, vert4 : VERTEX
			list_of_vertexes : LIST[VERTEX]
		do
			if attached test_db as db then
				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_string ("teststring", "testvalue")
				create vert4.make (db)
				vert4.field_string ("teststring", "testvalue")
				create vert2.make (db)
				vert2.field_string ("teststring", "testvalue")
				create vert3.make (db)
				vert3.field_string ("teststringOtherLabel", "testvalue4")
				vert.save
				vert2.save
				vert3.save
				vert4.save
				db.commit

				assert ("Contains 4 vertexes", db.get_number_of_vertexes = 4)
				list_of_vertexes := db.get_vertexes ("teststring")
				assert ("Contains 3 vertexes", list_of_vertexes.count = 3)
				list_of_vertexes.start()
				assert ( "Correct value", list_of_vertexes.item.get_field_string ("teststring").is_equal ("testvalue"))
				list_of_vertexes := db.get_vertexes ("wrong label")
				assert ("Is empty", list_of_vertexes.count = 0)

				db.begin_optimistic_transition
				vert.delete
				vert2.delete
				vert3.delete
				vert4.delete
				db.commit
			else
				assert("Could not contact test db", false)
			end
		end


	get_vertex
			--
		local
			vert : VERTEX
		do
			if attached test_db as db then

				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_string ("Testdata", "valuedata")
				vert.save
				db.commit
				assert ("Is not empty", db.get_number_of_vertexes = 1)

				if attached db.get_vertex ("Testdata", "valuedata") as vert2 then
					vert2.delete
					db.commit
				else
					assert("Could not find vertex", false)
				end
			else
				assert("Could not contact test db", false)
			end
		end

	set_get_root_vertex
			--
		local
			vert: VERTEX
		do
			if attached test_db as db then

				db.begin_optimistic_transition
				create vert.make (db)
				vert.field_string ("Testdata", "valuedata")
				vert.save
				db.commit
				assert ("Is not empty", db.get_number_of_vertexes = 1)
				db.set_root_vertex (vert)
				db.commit
				if not attached  db.get_root_vertex as root_v then
					assert("Found root vertex", false)
				else
					assert("Correct field in root vertex", root_v.get_field_string ("Testdata").is_equal ("valuedata"))
				end


				if attached db.get_vertex ("Testdata", "valuedata") as vert2 then
					vert2.delete
					db.commit
				else
					assert("Found vertex", false)
				end
			else
				assert("Could not contact test db", false)
			end
		end

	get_out_edge
	local
		vert1,vert2: VERTEX
		e: EDGE
	do
		if attached test_db as db then

			db.begin_optimistic_transition
			create vert1.make (db)
			vert1.field_string ("Testdata", "valuedata")
			create vert2.make (db)
			vert2.field_string ("Testdata", "valuedata")
			create e.make (db, vert1, vert2)
			e.field_string ("label1", "test")
			e.save
			db.commit

			if not attached  db.get_out_edge (vert1, "test") as e_result then
				assert ("Was able to get edge", false)
			end

			e.delete
			vert1.delete
			vert2.delete
			db.commit
		else
			assert("Could not contact test db", false)
		end
	end

	try_to_get_out_edge_for_ --label_that_des_not_exist
	local
		vert1,vert2: VERTEX
		e: EDGE
	do
		if attached test_db as db then

			db.begin_optimistic_transition
			create vert1.make (db)
			vert1.field_string ("Testdata", "valuedata")
			create vert2.make (db)
			vert2.field_string ("Testdata", "valuedata")
			create e.make (db, vert1, vert2)
			e.field_string ("label", "test")
			e.save
			db.commit

			if attached  db.get_out_edge (vert2, "tes") as e_result then
				assert ("Was not able to get edge", false)
			end

			e.delete
			vert1.delete
			vert2.delete
			db.commit
		else
			assert("Could not contact test db", false)
		end
	end





    get_in_edge
	local
		vert1,vert2: VERTEX
		e: EDGE
	do
		if attached test_db as db then
			db.begin_optimistic_transition
			create vert1.make (db)
			vert1.field_string ("Testdata", "valuedata")
			create vert2.make (db)
			vert2.field_string ("Testdata", "valuedata")
			create e.make (db, vert1, vert2)
			e.field_string ("label1", "test")
			e.save
			db.commit

			if not attached db.get_in_edge (vert2, "test") as e_result then
				assert ("Was not able to get edge", false)
			end

			e.delete
			vert1.delete
			vert2.delete
			db.commit
		else
			assert("Could not contact test db", false)
		end
	end

    get_out_and_in_vertexes
	local
		vert1,vert2: VERTEX
		e: EDGE
	do
		if attached test_db as db then

			db.begin_optimistic_transition
			create vert1.make (db)
			vert1.field_string ("Testdata", "valuedata")
			create vert2.make (db)
			vert2.field_string ("Testdata", "valuedata")
			create e.make (db, vert1, vert2)
			e.field_string ("label", "test")
			e.save
			db.commit

			if not attached  db.get_in_vertex (e) as v_result then
				assert ("Was able to get vertex", false)
			end
			if not attached  db.get_out_vertex (e) as v_result then
				assert ("Was able to get vertex", false)
			end

			e.delete
			vert1.delete
			vert2.delete
			db.commit
		else
			assert("Could not contact test db", false)
		end
	end


    get_number_of_Relations
	local
		vert1,vert2,vert3 : VERTEX
		e1,e2: EDGE

	do
		if attached test_db as db then
			create vert1.make (db)
			vert1.field_string ("Testdata", "valuedata")
			create vert2.make (db)
			vert2.field_string ("Testdata", "valuedata")
			create vert3.make (db)
			vert3.field_string ("Testdata", "valuedata")
			create e1.make (db, vert1, vert2)
			e1.field_string ("label1", "test")
			create e2.make (db, vert1, vert3)
			e2.field_string ("label1", "test")
			db.commit

			assert ("Correct number of relations",  db.get_number_of_relations (vert1, "test") = 2)
			vert1.delete
			vert2.delete
			vert3.delete
			db.commit
		else
			assert("Could not contact test db", false)
		end
	end


    get_relations
	local
		vert1,vert2,vert3 : VERTEX
		e1,e2: EDGE
		array_of_edges : ARRAYED_LIST [EDGE]
	do
		if attached test_db as db then

			create vert1.make (db)
			vert1.field_string ("Testdata", "valuedata")
			create vert2.make (db)
			vert2.field_string ("Testdata", "valuedata")
			create vert3.make (db)
			vert3.field_string ("Testdata", "valuedata")
			create e1.make (db, vert1, vert2)
			e1.field_string ("label1", "test")
			create e2.make (db, vert1, vert3)
			e2.field_string ("label1", "test")
			db.commit
			array_of_edges :=  db.get_relations (vert1, "test")

			assert ("Correct number of relations",  array_of_edges.count = 2)
			array_of_edges.start()
			assert ("Correct first label",  array_of_edges.item.get_field_string ("label1").is_equal ("test")   )
			array_of_edges.move (1)
			assert ("Correct second label",  array_of_edges.item.get_field_string ("label1").is_equal ("test")   )
			vert1.delete
			vert2.delete
			vert3.delete
			db.commit
		else
			assert("Could not contact test db", false)
		end
	end



feature {NONE}

	test_db: detachable GRAPHDATABASE


end


