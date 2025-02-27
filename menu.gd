extends Control

func _ready() -> void:
	if !OS.has_feature("pc"):
		$Content/Exit.hide()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")
