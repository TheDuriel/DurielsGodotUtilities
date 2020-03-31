extends VBoxContainer
"""
	SimilaritySearch Scene Script
"""
signal entry_selected(search_term)
signal entry_chosen(search_term)

export(Array, String) var search_items: Array = []

onready var _line_edit: LineEdit = $"LineEdit"
onready var _rtl: RichTextLabel = $"RichTextLabel"

var _search_term: String = ""
var _sorted_terms: Array = []


	# Remove this before using it in your own project.
func _init() -> void:
	search_items = _test_data


func _ready() -> void:
	_update_search()


func _select_entry() -> void:
	if _search_term == "":
		return
	else:
		_search_term = _sorted_terms[0]
		_update_search()
		emit_signal("entry_selected", _search_term)


func _accept_entry() -> void:
	emit_signal("entry_chosen", _search_term)


func _update_search() -> void:
	_search_term = _line_edit.text
	
	_rtl.clear()
	
	if _search_term == "":
		for i in search_items:
			_rtl.append_bbcode("[url]%s[/url]" % i)
			_rtl.newline()
		
	else:
		_sorted_terms = search_items.duplicate()
		_sorted_terms.sort_custom(self, "_similarity_sort")
		
		for i in _sorted_terms:
			_rtl.append_bbcode("[url]%s[/url]" % i)
			_rtl.newline()
	
	_rtl.scroll_to_line(0)


func _on_LineEdit_text_changed(new_text: String) -> void:
	_update_search()


func _on_LineEdit_text_entered(new_text: String) -> void:
	_accept_entry()


func _on_RichTextLabel_meta_clicked(meta) -> void:
	_search_term = meta
	_line_edit.text = _search_term
	emit_signal("entry_selected", _search_term)
	_update_search()


func _similarity_sort(a: String, b: String) -> bool:
	return true if a.similarity(_search_term) > b.similarity(_search_term) else false


	# Remove this before using it in your own project.
var _test_data: Array = [
		"brown",
		"warm",
		"essay",
		"outlook",
		"hallway",
		"have",
		"supply",
		"recovery",
		"grain",
		"steep",
		"seek",
		"tasty",
		"linen",
		"random",
		"engagement",
		"shelf",
		"calf",
		"fail",
		"beneficiary",
		"automatic",
		]
