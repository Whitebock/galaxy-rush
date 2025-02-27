extends Node2D
class_name Ship

var projectile = preload("res://game/projectile.tscn")
const MAX_HEALTH = 10
@export var speed = 1.5
@export var health = MAX_HEALTH
@export var projectile_pool: Node
@export var upgrades = []
@export var invincible = false
var direction = Vector2.ZERO
var shoot_pressed = false

func _ready() -> void:
	health = SaveData.health
	if SaveData.upgrades.has("faster_ship"):
		speed *= 2
	if SaveData.upgrades.has("double_shot"):
		$Sprite.frame = 1
	if SaveData.upgrades.has("quintuple_shot"):
		$Sprite.frame = 2
	if SaveData.upgrades.has("automatic_double_shot"):
		$Timer.start()

func _process(_delta: float) -> void:
	position += direction * speed
	position.y = clamp(position.y, 10 + 16, 180 - 16)
	
	if position.x > 350:
		hide()
		direction = Vector2.ZERO
	
	if shoot_pressed:
		_shoot()

func _shoot(auto = false):
	var from = [$Tier_1]
	if SaveData.upgrades.has("double_shot"):
		from = [$Tier_2_1, $Tier_2_2]
	if SaveData.upgrades.has("triple_shot"):
		from = [$Tier_1, $Tier_2_1, $Tier_2_2]
	if SaveData.upgrades.has("quintuple_shot"):
		from = [$Tier_1, $Tier_2_1, $Tier_2_2, $Tier_3_1, $Tier_3_2]
	if auto:
		from = [$Tier_2_1, $Tier_2_2]
	for spawner in from:
		var shot: Node2D = projectile.instantiate()
		shot.global_position = spawner.global_position
		projectile_pool.add_child(shot)
	$ShotAudio.play()
	shoot_pressed = false

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if invincible: return
	if area is Asteroid and area.health > 0:
		health -= 1
		SaveData.health = health
		area.destroy()

func _on_round_timer_timeout() -> void:
	invincible = true

func move_off_screen():
	direction += Vector2.RIGHT * 2
	
