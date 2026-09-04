extends CharacterBody2D

const SPEED = 100.0


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
	#if not close enough to target
	if(target.position.distance_to(position) < Vector2(10,10).length()):
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
