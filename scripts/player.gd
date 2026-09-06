extends CharacterBody2D

const SPEED = 200.0

var health: float = 5
var last_direction: Vector2 = Vector2.RIGHT
var weapons: Dictionary = {
	"explosion": preload("res://ressources/explosion_weapon.tres"),
	"freeze": preload("res://ressources/freeze_weapon.tres"),
	"shield": preload("res://ressources/shield_weapon.tres"),
}
var can_move: bool = true
var new_buff # to contain the active buff instance
var shield = 0 # player shield
var invincible = false #to make player invincible after taking damage

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var enemy_collision : Node2D # check if ennemy is colliding with player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var Level: Node2D = $".".get_parent()
@onready var effects = $Effects
@onready var playerWalkAudioStream = $AudioStreamPlayerWalk
@onready var playerHitAudioStream = $AudioStreamPlayerHit
@onready var playerShieldHitAudioStream = $AudioStreamPlayerShieldHit
@onready var playerShieldBreakAudioStream = $AudioStreamPlayerShieldBreak

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
signal health_changed

#func _ready() -> void:
#	effects.play("RESET")


func _physics_process(_delta: float) -> void:	
	if Input.is_action_just_pressed("explosion") and weapons["explosion"].is_ready:
		shoot(last_direction, weapons["explosion"])
	elif Input.is_action_just_pressed("freeze") and weapons["freeze"].is_ready:
		shoot(last_direction, weapons["freeze"])
	elif Input.is_action_just_pressed("shield") and weapons["shield"].is_ready:
		shoot(last_direction, weapons["shield"])
	
	if can_move:
		_process_movement()
	_process_animation()
	_process_collisions()
	move_and_slide()
	
	#Manage camera position
	move_camera_to_match_player_pos()


func _process_collisions() -> void:
	if enemy_collision and enemy_collision in $PlayerHitBox.get_overlapping_areas():
		take_damage(enemy_collision.get_parent().damage)


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
		_play_walk_sound()
	else:
		_play_animation("idle", last_direction)
		_stop_walk_sound()

func _play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x < 0:
		animated_sprite_2d.play(prefix + "_left")
	elif dir.x > 0:
		animated_sprite_2d.play(prefix + "_right")
	elif dir.y < 0 :
		animated_sprite_2d.play(prefix + "_up")
	else :
		animated_sprite_2d.play(prefix + "_down")

func _play_walk_sound() -> void:
	if !playerWalkAudioStream.playing:
		playerWalkAudioStream.play()

func _stop_walk_sound() -> void:
	playerWalkAudioStream.stop()
	
func move_camera_to_match_player_pos():
	if position.y < camera_limit_upper - 10:
		camera_limit_lower -= camera_height
		camera_limit_upper -= camera_height
		player_map_position.y -= 1
		player_is_in_room.emit(player_map_position,position)
		change_camera_pos_y.emit(camera_limit_upper)
		
	if position.y > camera_limit_lower + 10:
		camera_limit_lower += camera_height
		camera_limit_upper += camera_height
		player_map_position.y += 1
		player_is_in_room.emit(player_map_position, position)
		change_camera_pos_y.emit(camera_limit_upper)
		
	if position.x < camera_limit_left - 10:
		camera_limit_left -= camera_width
		camera_limit_right -= camera_width
		player_map_position.x -= 1
		player_is_in_room.emit(player_map_position, position)
		change_camera_pos_x.emit(camera_limit_left)

	if position.x > camera_limit_right + 10:
		camera_limit_left += camera_width
		camera_limit_right += camera_width
		player_map_position.x += 1
		player_is_in_room.emit(player_map_position, position)
		change_camera_pos_x.emit(camera_limit_left)		
	
func shoot(direction: Vector2, weapon: WeaponRessource):
	weapon.is_ready = false
	match weapon.name:
		"explosion":
			$ExplosionTimer.start(weapon.cooldown)
		"freeze":
			$FreezeTimer.start(weapon.cooldown)
		#"shield":
		#	$ShieldTimer.start(weapon.cooldown)
	if weapon.name == "shield":
		const BUFF = preload("res://scenes/buff.tscn")
		new_buff = BUFF.instantiate()
		new_buff.global_position = global_position
		new_buff.direction = direction
		new_buff.weapon = weapon
		shield = new_buff.weapon.power # give shield to the player
		
		Level.add_child(new_buff)
	else:
		const PROJECTILE = preload("res://scenes/Projectile.tscn")
		var new_projectile = PROJECTILE.instantiate()
		new_projectile.global_position = global_position
		new_projectile.direction = direction
		new_projectile.weapon = weapon
		Level.add_child(new_projectile)
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func _on_explosion_timer_timeout() -> void:
	weapons["explosion"].is_ready = true


func _on_freeze_timer_timeout() -> void:
	weapons["freeze"].is_ready = true


func _on_shield_timer_timeout() -> void:
	print("shield available")
	weapons["shield"].is_ready = true

func take_damage(taked_damage: float):
	if not invincible:
		var damage_taken = max(taked_damage - shield, 0)
		print("Health:" + str(health) + " damage taken:" + str(damage_taken))
		$InvincibilityTimer.start()
		invincible = true
		health -= damage_taken
		if damage_taken > 0:
			playerHitAudioStream.play()
			health_changed.emit(-damage_taken)
			effects.play("hurtBlink")
		else:
			effects.play("shieldBlink")
		

		# Manage shield
		if shield > 0:
			shield -= taked_damage
			if shield <= 0:
				shield = 0
				if new_buff:
					playerShieldBreakAudioStream.play()
					$ShieldTimer.start(weapons["shield"].cooldown)
					new_buff.queue_free()
			else:
				playerShieldHitAudioStream.play()
		
	if health <= 0:
		#death
		pass
	else:
		#invincibility
		pass


func _on_invincibility_timer_timeout() -> void:
	invincible = false
	effects.stop(false)




func _on_area_2d_area_entered(area: Area2D) -> void:
		if area.name == "EnemyHitArea":
			enemy_collision = area
			print("Ouch")
			take_damage(area.get_parent().damage)
