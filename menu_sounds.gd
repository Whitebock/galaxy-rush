extends Node

var hover: AudioStreamPlayer
var pressed: AudioStreamPlayer
var music: AudioStreamPlayer

func _enter_tree() -> void:
	get_tree().root.child_entered_tree.connect(_on_new_node)

func _ready() -> void:
	hover = AudioStreamPlayer.new()
	hover.stream = preload("res://assets/sounds/Retro Beeep 20.wav")
	hover.bus = "UI"
	add_child(hover)
	pressed = AudioStreamPlayer.new()
	pressed.stream = preload("res://assets/sounds/Retro Event Acute 11.wav")
	pressed.bus = "UI"
	add_child(pressed)
	music = AudioStreamPlayer.new()
	music.stream = preload("res://assets/music/crystal_starlight.wav")
	music.bus = "Music"
	music.autoplay = true
	add_child(music)

func _on_new_node(parent: Node):
	for node in parent.get_children():
		if node is BaseButton and node is not OptionButton:
			node.mouse_entered.connect(func(): hover.play())
			node.pressed.connect(func(): pressed.play())
		_on_new_node(node)

func toggle_music():
	music.playing = !music.playing
