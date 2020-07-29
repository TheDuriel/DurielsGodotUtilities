tool
extends PanelContainer
"""
	RichTextEditor Scene Script
"""

onready var _textedit: TextEdit = $"H/TextEdit"
onready var _rtl_p: PanelContainer = $"H/P"
onready var _rtl: RichTextLabel = $"H/P/RichTextLabel"


func _ready():
	_textedit.add_color_region("[", "]", Color(1,1,0))


func can_drop_data(position: Vector2, data) -> bool:
	if data is Dictionary and data.type == "files":
		if data.files[0].ends_with(".tres") or data.files[0].ends_with(".theme"):
			var file = load(data.files[0])
			if file is Theme:
				return true
	return false


func drop_data(position: Vector2, data) -> void:
	if data is Dictionary and data.type == "files":
		if data.files[0].ends_with(".tres") or data.files[0].ends_with(".theme"):
			var file = load(data.files[0])
			if file is Theme:
				_rtl_p.theme = file


func _on_TextEdit_text_changed() -> void:
	_rtl.parse_bbcode(_textedit.text)


func _on_bbold_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[b]", text, "[/b]")
	_textedit.insert_text_at_cursor(new_text)


func _on_bitalic_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[i]", text, "[/i]")
	_textedit.insert_text_at_cursor(new_text)


func _on_bunder_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[u]", text, "[/u]")
	_textedit.insert_text_at_cursor(new_text)


func _on_bcode_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[code]", text, "[/code]")
	_textedit.insert_text_at_cursor(new_text)


func _on_bcenter_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[center]", text, "[/center]")
	_textedit.insert_text_at_cursor(new_text)


func _on_bright_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[right]", text, "[/right]")
	_textedit.insert_text_at_cursor(new_text)


func _on_bfill_pressed():
	var text = _textedit.get_selection_text()
	var new_text = str("[fill]", text, "[/fill]")
	_textedit.insert_text_at_cursor(new_text)


func _on_TextEdit_gui_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_B and Input.is_key_pressed(KEY_CONTROL):
			accept_event()
			_on_bbold_pressed()
		if event.scancode == KEY_I and Input.is_key_pressed(KEY_CONTROL):
			accept_event()
			_on_bbold_pressed()
		if event.scancode == KEY_U and Input.is_key_pressed(KEY_CONTROL):
			accept_event()
			_on_bbold_pressed()
		if event.scancode == KEY_M and Input.is_key_pressed(KEY_CONTROL):
			accept_event()
			_on_bcode_pressed()
