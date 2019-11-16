var err: int = OK
var dir: Directory = Directory.new()

err = dir.open(folder_path)
print("Open State: ", err)

if not err == OK:
	return

err = dir.list_dir_being(true, true) # Skip navigation, skip hidden
print("List State: ", err)

if not err == ok:
	return

var current_item: String = dir.get_next()

while current_item != "":
	#do_things_here
	
	current_item = dir.get_next()