extends CharacterBody2D

const SPEED = 300.0

var last_direction: Vector2 = Vector2.RIGHT

@onready
var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	_process_movement()
	_process_animation()
	move_and_slide()

func _process_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else :
		velocity = Vector2.ZERO

func _process_animation() -> void:
	if velocity != Vector2.ZERO:
		_play_animation("move", last_direction)
	else:
		_play_animation("idle", last_direction)

func _play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x < 0:
		animated_sprite_2d.play(prefix + "_left")
	elif dir.x > 0:
		animated_sprite_2d.play(prefix + "_right")
	elif dir.y < 0 :
		animated_sprite_2d.play(prefix + "_up")
	else :
		animated_sprite_2d.play(prefix + "_down")
