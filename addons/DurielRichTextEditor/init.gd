tool
extends EditorPlugin

var _editor_tscn: PackedScene = preload("./RichTextEditor.tscn")
var _editor_instance: PanelContainer


func _enter_tree() -> void:
	_editor_instance = _editor_tscn.instance()
	add_control_to_bottom_panel(_editor_instance, "RichTextEdit")


func _exit_tree() -> void:
	remove_control_from_bottom_panel(_editor_instance)
	_editor_instance.queue_free()
