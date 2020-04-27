tool
extends Label
class_name HeaderLabel


func _init() -> void:
	name = "HeaderLabel"
	align = Label.ALIGN_CENTER
	add_font_override("font", preload("res://Theme/Fonts/Header.tres"))
	add_color_override("font_color", Color8(255, 228, 202))
