extends Area2D
class_name Projectile

@export var speed = 8

func _process(_delta: float) -> void:
	position.x += 1 * speed
	if position.x > 330:
		queue_free()
