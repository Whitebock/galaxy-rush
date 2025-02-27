extends Node

var galaxy_level = false
var galaxy_animation = false

@onready var ship: Ship = %Ship

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	galaxy_level = SaveData.level == 5

func _process(_delta: float) -> void:
	# Progress Bar (Until end of level)
	var percent_left = 1 - (%RoundTimer.time_left / %RoundTimer.wait_time)
	$Progress/Value.value = floori($Progress/Value.max_value * percent_left)
	
	# Health Bar
	$Health/Value.value = ship.health
	
	if ship.health <= 0:
		_show_popup(
			"Game Over",
			"Your ship did not make it to the galaxy",
			true
		)
		get_tree().paused = true
		%LossSound.play()
	
	# Play animation for last level
	if galaxy_animation:
		%Galaxy.position.x -= 2
	if %Galaxy.position.x <= -600:
		if not $GameOver_Popup.visible:
			_show_popup(
				"Adventure Completed",
				"Congrats, you reached the galaxy! \n\nScore: " + str(SaveData.score),
				true
			)
			%VictorySound.play()
	if %Galaxy.position.x <= -800:
		galaxy_animation = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ship_up"):
		ship.direction.y = -1
	if event.is_action_pressed("ship_down"):
		ship.direction.y = 1
		
	if !Input.is_action_pressed("ship_up") && !Input.is_action_pressed("ship_down"):
		ship.direction.y = 0
	
	if event.is_action_pressed("ship_shoot"):
		ship.shoot_pressed = true

func _on_timer_timeout() -> void:
	if galaxy_level:
		galaxy_animation = true
		return
	_show_popup(
		"Mission Success",
		"Congrats, you are one step closer to the center of the galaxy!"
	)
	%VictorySound.play()

func _on_continue_pressed() -> void:
	MenuSounds.toggle_music()
	SaveData.level += 1
	get_tree().change_scene_to_file("res://level_select.tscn")

func _on_back_pressed() -> void:
	MenuSounds.toggle_music()
	SaveData.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")

func _show_popup(title: String, content: String, back_to_menu = false):
	if $GameOver_Popup.visible: return
	%PopupContent/Header.text = title
	%PopupContent/Label.text = content
	
	%PopupContent/Back.visible = back_to_menu
	%PopupContent/Continue.visible = !back_to_menu
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MenuSounds.toggle_music()
	ship.move_off_screen()
	
	$GameOver_Popup.show()
