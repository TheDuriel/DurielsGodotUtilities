extends VBoxContainer

	# Warning, changing these will cause a full reset
export(Array, String) var entries: Array = [] setget set_entries
export(int) var min_value: int = 0
export(int) var max_value: int = 3
export(int) var points: int = 10

onready var _entry_container: VBoxContainer = $"Entries"
	# EntryName : Entry.tscn
var _entries_by_name: Dictionary = {}


func set_entries(new_value: Array) -> void:
	for i in new_value:
		if not i is String:
			new_value.erase(i)
	entries = new_value
	if is_inside_tree():
		_generate_entries()


func _ready() -> void:
	_generate_entries()


func _generate_entries() -> void:
	# Remove old stuff
	for i in _entry_container.get_children():
		i.queue_free()
	
	#_entry_container.rect_size = Vector2.ZERO # Reset container size.
	
	yield(get_tree(), "idle_frame") # Wait for free.
	
	# Generate entry objects
	for entry_name in entries:
		var e: VBoxContainer = preload("./Entry.tscn").new()
		_entry_container.add_child(e)
		_entries_by_name[entry_name] = e
		e.connect("sub_request", self, "_on_Entry_sub_request")
		e.connect("add_request", self, "_on_Entry_add_request")


func _on_Entry_sub_request(entry_name: String) -> void:
	pass


func _on_Entry_add_request(entry_name: String) -> void:
	pass
