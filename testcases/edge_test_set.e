note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	EDGE_TEST_SET

inherit
	INTERNAL
	undefine
		default_create
		end
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
			else
				assert("Could not contact test db", false)
			end
		end

	on_clean
			-- <Precursor>
		do
			if attached test_db as db then
				db.close
				assert ("Is closed", not db.is_database_open)
			else
				assert("Could not contact test db", false)
			end
		end

feature -- Test routines

	create_edge
	local
		ed :EDGE
		v1, v2 : VERTEX
			-- Only create it. Do not save it.
		do
			if attached test_db as db then
				create v1.make (db)
				create v2.make (db)
				create ed.make (db, v1, v2)
-- TODO			assert ("", )
			else
				assert("Could not contact test db", false)
			end
		end

	set_string_value_at_edge
			--
	local
		ed :EDGE
		v1, v2 : VERTEX
			-- Only create it. Do not save it.
		do
			if attached test_db as db then

				create v1.make (db)
				create v2.make (db)
				create ed.make (db, v1, v2)
				ed.field_string ("label", "rough_estimate")
			else
				assert("Could not contact test db", false)
			end
		end

	get_string_value_at_edge
			--
	local
		ed :EDGE
		v1, v2 : VERTEX
			-- Only create it. Do not save it.
		do
			if attached test_db as db then

				create v1.make (db)
				create v2.make (db)
				create ed.make (db, v1, v2)
				ed.field_string ("label", "rough_estimate")
				assert ("Correct label at edge", ed.get_field_string ("label").is_equal ("rough_estimate"))
			else
				assert("Could not contact test db", false)
			end
		end


	test_remove_edge_two_transactions
			-- Test case created due to problems with removing an edge. One must look in the database to make sure it is ok. TODO rewrite test cases so that this check is automatic
	local
		ed :EDGE
		v1, v2 : VERTEX
			--
		do
			if attached test_db as db then
				db.begin_optimistic_transition
				create v1.make (db)
				create v2.make (db)
				create ed.make (db, v1, v2)
				db.commit
				db.begin_optimistic_transition
				ed.delete
				db.commit
			else
				assert("Could not contact test db", false)
			end
		end

feature {NONE}

	test_db: detachable GRAPHDATABASE

end


