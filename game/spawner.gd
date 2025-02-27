extends Node

var asteroid_small = preload("res://game/asteroid_small.tscn")
var asteroid_mid = preload("res://game/asteroid_mid.tscn")
var asteroid_big = preload("res://game/asteroid_big.tscn")

func _spawn_asteroid():
	var a: Asteroid
	if randf() < 0.08 + (SaveData.level * 0.02):
		# Spawn a bigger one
		if SaveData.level > 1 && randf() < SaveData.level * 0.01:
			a = asteroid_big.instantiate()
		else:
			a = asteroid_mid.instantiate()
	else:
		a = asteroid_small.instantiate()
	var y_pos =  clampi(int(randfn(90, 80)), 10, 170)
	a.position = Vector2(350, y_pos)
	add_child(a)

func _on_spawn_timer_timeout() -> void:
	_spawn_asteroid()
	%SpawnTimer.wait_time = randf_range(0.1, max(0.6 - (SaveData.level * 0.1), 0.2))

func _on_round_timer_timeout() -> void:
	%SpawnTimer.stop()
