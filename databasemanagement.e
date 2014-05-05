note
	description: "Summary description for {DATABASEMANAGEMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASEMANAGEMENT

inherit
	INTERNAL

create
	make,
	make_for_test

feature

	make
	do
		test_folder_name :=""
	end
	make_for_test
	local
		e : EDGE
		v : VERTEX
		g : GRAPHDATABASE
	do
		test_folder_name :=""
	end

	create_test_database ( test_class : ANY)
		local
			env : EQA_ENVIRONMENT
			test_name : STRING
			original_folder_name : STRING
			execu_env : EXECUTION_ENVIRONMENT

		do
			test_name := "UNKNOWN_TEST_NAME"
			create env
			if attached {IMMUTABLE_STRING_8} env.get ("TEST_NAME") as name  then
				test_name := name
			end
			create execu_env
			create test_folder_name.make_from_string (execu_env.current_working_directory + "\test_eODB\" + class_name(test_class) + test_name)
			create original_folder_name.make_from_string (execu_env.current_working_directory + "\emptyDB")

			create_database_internal (original_folder_name, test_folder_name)
		end



	test_folder_name : STRING



feature {NONE}



	create_database_internal (original_folder_name, project_folder_name : STRING)
	local
			original_folder : DIRECTORY
			project_folder : DIRECTORY
			original_file : RAW_FILE
			destination_file : RAW_FILE

	do

			create project_folder.make (project_folder_name)
			if not project_folder.exists then
				project_folder.recursive_create_dir
			end
			create original_folder.make (original_folder_name)

			original_folder.open_read

			from
				original_folder.readentry
			until
				original_folder.lastentry = Void
			loop
				if attached original_folder.lastentry as last_entry then
					create original_file.make (original_folder.name + "\" + last_entry) -- This is the only way (?) to get knowledge of if it is a file or a directory entry we have found.
					if not original_file.is_directory then
						create destination_file.make (project_folder_name + "\" + last_entry)
						destination_file.open_write
						original_file.open_read
						original_file.copy_to (destination_file)
						destination_file.close
						original_file.close
					end
				end
				original_folder.readentry
			end
	end
end
