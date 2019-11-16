extends Node
"""
	SFXPlayer Class Script
	Plays Sound effects on up to N channels.
	Use: call play_sound(sfx_file_path)
	Will queue sounds if all channels are busy.
"""
	#set the number of desired audio channels
const TOTAL_STREAMS = 8

	#dont touch
onready var streams = []
var available_streams = []
var todo = []


	#initialize streams
func _ready():
	for i in range(TOTAL_STREAMS):
		var n = AudioStreamPlayer.new()
		add_child(n)
		streams.append(n)
		available_streams.append(n)
		n.connect("finished", self, "on_stream_finished", [n])
		n.autoplay = true
		n.bus = "master"


func on_stream_finished(stream):
	available_streams.append(stream)


func play_sound(sound_path):
	if not todo.has(sound_path):
		todo.append(sound_path)


func _process(delta):
	if not todo.empty() and not available_streams.empty():
		available_streams[0].stream = load(todo[0])
		todo.pop_front()
		available_streams[0].play()
		available_streams.pop_front()