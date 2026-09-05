extends CharacterBody2D

const SPEED = 100.0

var health: int = 5
var damage: int = 1

@onready
var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN
var target = null

func _physics_process(_delta: float) -> void:
	
	_process_animation()
	if target:	
		_attack(_delta)
		move_and_slide()



func _attack(delta: float) -> void:
	var direction = Vector2.ZERO
	#if not on target
	if((target.position - position).abs() < Vector2(10,10).abs()):
		direction = Vector2.ZERO
	else:
		direction = (target.position - position).normalized()
		position += direction * SPEED * delta
	
	#get last direction orientation
	if direction != Vector2.ZERO:
		last_direction = direction


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


func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body

func take_damage(damage: int) -> void:
	health -= damage
	# damage animation then :
	if health <= 0:
		# death animation then :
		queue_free()
