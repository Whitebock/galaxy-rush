extends Area2D
class_name Asteroid

@export var health = 3
@export var speed = 1
@onready var sprite: AnimatedSprite2D = $AnimatedSprite

var hitsound: AudioStreamPlayer
var gives_score = 0

func _ready() -> void:
	gives_score = health * speed
	sprite.animation = "default"
	sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count("default") - 1)
	hitsound = AudioStreamPlayer.new()
	hitsound.stream = preload("res://assets/sounds/Retro Impact Punch Hurt 01.wav")
	hitsound.bus = "SFX"
	hitsound.volume_db = 8
	add_child(hitsound)

func _process(_delta: float) -> void:
	position.x -= 1 * speed
	if position.x < -20:
		queue_free()

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area is Projectile:
		area.hide()
		area.queue_free()
		health -= 1
		if health <= 0: 
			SaveData.score += gives_score
			destroy()

func destroy():
	health = 0
	if len(hitsound.finished.get_connections()) > 0: return
	hitsound.finished.connect(queue_free)
	sprite.play("destroy")
	hitsound.play()
