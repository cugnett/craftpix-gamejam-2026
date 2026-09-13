extends CharacterBody2D


const SPEED = 70.0
const CHARGE_SPEED = 180.0
var speed = SPEED

var health: float = 150
const MAX_HEALTH = 150
var damage: float = 1
var min_x_position = 1440 
var max_x_position = 1780
var change_direction = false
var direction = Vector2(0,0)

var hit_area = "BossHitArea"

var activate_phase_2 = false
var activate_phase_3 = false
var death_phase = false


#music management
var background_music_position = 0.0

#attack charge vars
var trigger_attack_charge = false
var attack_charge = false

# rat attack vars
var rat_attack = false
var rat = load("res://scenes/enemy.tscn")
var rat_instance = null
var rat_list = []

var frame1 = load("res://assets/characters/rat.png")
var frame2 = load("res://assets/characters/rat_red.png")
var frame1_right = load("res://assets/characters/rat_right.png")
var frame2_right = load("res://assets/characters/rat_red_right.png")

var invicible = true #starts invicible before fight
var dialog_unplayed = true # to tell if boss dialog has been played or not
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("idle")
	

func _start_fight() -> void:
	get_parent().get_node("Player").can_move = true
	play_boss_music()
	get_node(hit_area).name = "EnemyHitArea" #change name so that player takes damage
	hit_area = "EnemyHitArea"
	$MoveTimer.start()
	$AttackChargeTriggerTimer.start()
	direction = Vector2(-1,0)
	invicible = false

func _stop_fight() -> void:
	stop_boss_music()
	get_node(hit_area).get_node("CollisionPolygon2D").disabled = true
	$MoveTimer.stop()
	$AttackChargeTriggerTimer.stop()
	direction = Vector2(0,0)
	invicible = true
	z_index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_move(delta)
	_manage_phase()
	move_and_slide()
	


func take_damage(taked_damage: float) -> void:
	if not invicible:
		print("Boss take damage")
		health -= taked_damage
		print(health)
		$Effects.play("boss_damage")
		# damage animation then :
	elif dialog_unplayed:
		dialog_unplayed = false
		$DialogueActionable2D.action()
		get_parent().get_node("Player").can_move = false


func _move(delta: float) -> void:
	if trigger_attack_charge:
		print("Attack charge trigger timer expired:")
		trigger_attack_charge = false
		$AttackChargeTriggerTimer.wait_time = randf_range(4.0,6.0)
		_attack_charge()
	elif attack_charge:
		pass
	elif change_direction:
		print("Move timer expired:" + str($MoveTimer.wait_time))
		change_direction = false
		$MoveTimer.wait_time = randi_range(3,6)
		direction *= Vector2(-1,0)

		if position.x < min_x_position:
			print(str(position))
			direction = Vector2(1,0)
		if position.x > max_x_position:
			print(str(position))
			direction = Vector2(-1,0)
	# slide from left to right and go the other way after a random time
	position += direction * speed * delta
	
func _attack_charge() -> void:
	var player_pos = get_parent().get_node("Player").position
	attack_charge = true
	speed = CHARGE_SPEED
	$AttackChargeTimer.start()
	direction = (get_parent().get_node("Player").position - position).normalized()

func _manage_phase():
	if health < MAX_HEALTH * 2/3 and activate_phase_2 == false:
		activate_phase_2 = true
		_create_rat_instance(Vector2(0,0))
	if health < MAX_HEALTH * 1/3 and activate_phase_3 == false:
		activate_phase_3 = true
		_create_rat_instance(Vector2(0,0))	
		await $RatInvocationSfx.finished
		_create_rat_instance(Vector2(50,50))
	if health <= 0 and death_phase == false:
			death_phase = true
			_stop_fight()
			# death animation then :
			kill_rats()
			$AnimationPlayer.play("death2")
			SignalManager.boss_defeated.emit()
		

func kill_rats():
	# delete all instanciated rats still existing
	for rat in rat_list:
		if rat:
			rat.queue_free()

func _create_rat_instance(position_offset):
		
		$RatInvocationSfx.play()
		
		rat_instance = rat.instantiate()
		
		rat_instance.speed = 100
		rat_instance.health = 10
		rat_instance.damage = 1
		
		rat_instance.get_node("Sight").get_node("CollisionShape2D").scale = Vector2(3.0,3.0)
		var rat_sprite_frames = SpriteFrames.new()
		rat_sprite_frames.add_animation("idle_left")
		rat_sprite_frames.set_animation_speed("idle_left", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("idle_left", true)   # Make it loop
		rat_sprite_frames.add_frame("idle_left", frame1)
		rat_sprite_frames.add_frame("idle_left", frame2)

		rat_sprite_frames.add_animation("idle_right")
		rat_sprite_frames.set_animation_speed("idle_right", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("idle_right", true)   # Make it loop
		rat_sprite_frames.add_frame("idle_right", frame1_right)
		rat_sprite_frames.add_frame("idle_right", frame2_right)
		
		rat_sprite_frames.add_animation("idle_down")
		rat_sprite_frames.set_animation_speed("idle_down", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("idle_down", true)   # Make it loop
		rat_sprite_frames.add_frame("idle_down", frame1_right)
		rat_sprite_frames.add_frame("idle_down", frame2_right)

		rat_sprite_frames.add_animation("idle_up")
		rat_sprite_frames.set_animation_speed("idle_up", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("idle_up", true)   # Make it loop
		rat_sprite_frames.add_frame("idle_up", frame1)
		rat_sprite_frames.add_frame("idle_up", frame2)

		rat_sprite_frames.add_animation("move_left")
		rat_sprite_frames.set_animation_speed("move_left", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("move_left", true)   # Make it loop
		rat_sprite_frames.add_frame("move_left", frame1)
		rat_sprite_frames.add_frame("move_left", frame2)

		rat_sprite_frames.add_animation("move_right")
		rat_sprite_frames.set_animation_speed("move_right", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("move_right", true)   # Make it loop
		rat_sprite_frames.add_frame("move_right", frame1_right)
		rat_sprite_frames.add_frame("move_right", frame2_right)
		
		rat_sprite_frames.add_animation("move_down")
		rat_sprite_frames.set_animation_speed("move_down", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("move_down", true)   # Make it loop
		rat_sprite_frames.add_frame("move_down", frame1_right)
		rat_sprite_frames.add_frame("move_down", frame2_right)

		rat_sprite_frames.add_animation("move_up")
		rat_sprite_frames.set_animation_speed("move_up", 1.0) # Set to 1 FPS
		rat_sprite_frames.set_animation_loop("move_up", true)   # Make it loop
		rat_sprite_frames.add_frame("move_up", frame1)
		rat_sprite_frames.add_frame("move_up", frame2)
		
		rat_instance.get_node("AnimatedSprite2D").sprite_frames = rat_sprite_frames
		rat_instance.position = position + position_offset
		
		rat_list.append(rat_instance)
		get_parent().add_child(rat_instance)
		rat_instance.get_node("AnimatedSprite2D").play("idle_left")
		
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and dialog_unplayed:
		dialog_unplayed = false
		$DialogueActionable2D.action()
		get_parent().get_node("Player").can_move = false

func play_boss_music() -> void:
	background_music_position = get_parent().get_node("AudioStreamBackground").get_playback_position()
	get_parent().get_node("AudioStreamBackground").stop()
	get_parent().get_node("AudioStreamFight").stop()
	get_parent().get_node("BossMusic").play()
	
func stop_boss_music() -> void:
	get_parent().get_node("BossMusic").stop()
	get_parent().get_node("AudioStreamBackground").play(background_music_position)
	

func _on_move_timer_timeout() -> void:
	change_direction = true


func _on_attack_charge_timer_timeout() -> void:
	attack_charge = false
	speed = SPEED

func _on_attack_charge_trigger_timer_timeout() -> void:
	trigger_attack_charge = true
	print("wait_time:" + str($AttackChargeTriggerTimer.wait_time))
