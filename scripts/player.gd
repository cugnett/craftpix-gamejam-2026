extends CharacterBody2D

const SPEED = 200.0

var last_direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var Weapon: Node2D = $Weapon

@export var camera_height: int = 256
@export var camera_width: int = 464
@export var camera_limit_lower: int = 256
@export var camera_limit_upper: int = 0
@export var camera_limit_right: int = 464
@export var camera_limit_left: int = 0

# player position on the map. (0,0) is determined by the room on the top left.
@export var player_map_position = Vector2(0,0)


signal change_camera_pos_y
signal change_camera_pos_x
signal player_is_in_room

func _physics_process(_delta: float) -> void:	
	if Input.is_action_just_pressed("attack1") and Weapon.is_ready:
		Weapon.shoot(last_direction, "attack1")
	elif Input.is_action_just_pressed("attack2") and Weapon.is_ready:
		Weapon.shoot(last_direction, "attack2")
	elif Input.is_action_just_pressed("attack3") and Weapon.is_ready:
		Weapon.shoot(last_direction, "attack3")

	_process_movement()
	_process_animation()
	move_and_slide()
	
	#Manage camera position
	move_camera_to_match_player_pos()

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

func move_camera_to_match_player_pos():
	if position.y < camera_limit_upper:
		camera_limit_lower -= camera_height
		camera_limit_upper -= camera_height
		player_map_position.y -= 1
		player_is_in_room.emit(player_map_position,position)
		change_camera_pos_y.emit(camera_limit_upper)
		
	if position.y > camera_limit_lower:
		camera_limit_lower += camera_height
		camera_limit_upper += camera_height
		player_map_position.y += 1
		player_is_in_room.emit(player_map_position, position)
		change_camera_pos_y.emit(camera_limit_upper)
		
	if position.x < camera_limit_left:
		camera_limit_left -= camera_width
		camera_limit_right -= camera_width
		player_map_position.x -= 1
		player_is_in_room.emit(player_map_position, position)
		change_camera_pos_x.emit(camera_limit_left)

	if position.x > camera_limit_right:
		camera_limit_left += camera_width
		camera_limit_right += camera_width
		player_map_position.x += 1
		player_is_in_room.emit(player_map_position, position)
		change_camera_pos_x.emit(camera_limit_left)		
	
	
	
