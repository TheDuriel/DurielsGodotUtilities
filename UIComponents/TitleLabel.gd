tool
extends Label
class_name TitleLabel


func _init() -> void:
	align = Label.ALIGN_CENTER
	add_font_override("font", preload("res://Theme/Fonts/Title.tres"))
	add_color_override("font_color", Color8(255, 228, 202))
