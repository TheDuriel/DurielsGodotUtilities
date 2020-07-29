extends HBoxContainer
"""
	Entry Scene Script
	SkillMenu Component
"""
signal sub_request(entry_name)
signal add_request(entry_name)

onready var _entryname: Label = $"EntryName"

var entry_name: String = "" setget set_entry_name
var value: int = 0


func set_entry_name(new_value: String) -> void:
	entry_name = new_value
	_entryname.text = entry_name


func _on_Subtract_pressed() -> void:
	emit_signal("sub_request", entry_name)


func _on_Add_pressed() -> void:
	emit_signal("add_request", entry_name)
