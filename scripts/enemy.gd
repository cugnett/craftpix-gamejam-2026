class_name Enemy
extends CharacterBody2D


var freezed: bool = false
var is_frozen: bool = false
var speed: float
var health: float
var damage: float


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_color_rect: ColorRect = $AnimatedSprite2D/EnemyColorRect


var last_direction: Vector2 = Vector2.DOWN
var target = null
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _ready() -> void:
	SignalManager.enemy_hurted.connect(enemy_is_hurted)

func _physics_process(delta: float) -> void:
	if !is_frozen:
		if knockback_timer > 0.0:
			velocity = knockback
			knockback_timer -= delta
			print("knockbar in : " + str(knockback_timer))
			if knockback_timer <= 0.0:
				knockback = Vector2.ZERO
				velocity = Vector2.ZERO
				print("end knockbar : " + str(knockback_timer))
		elif target:
			_process_animation()
			_attack(delta)
	move_and_slide()



func _attack(delta: float) -> void:
	var direction = Vector2.ZERO
	#if not close enough to target
	if(target.position.distance_to(position) < Vector2(10,10).length()):
		direction = Vector2.ZERO
	else:
		direction = (target.position - position).normalized()
		if !freezed:
			position += direction * speed * delta
	
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
		if target == null:
			SignalManager.enemy_hurted.emit()
		target = body

func take_damage(taked_damage: float) -> void:
	print("Enemy take damage")
	health -= taked_damage
	print(health)
	# target player if not already
	if target == null:
		target = get_parent().get_node("Player")
		SignalManager.enemy_hurted.emit()
	# damage animation then :
	if health <= 0:
		# death animation then :
		queue_free()
		
func frozen(freeze_power: float) -> void:
	is_frozen = true
	animated_sprite_2d.self_modulate = Color("1470acff")
	await get_tree().create_timer(freeze_power).timeout
	animated_sprite_2d.self_modulate = Color("#ffffffff")
	is_frozen = false
	# target player if not already
	if target == null:
		target = get_parent().get_node("Player")

func freeze(freeze_power: float) -> void:
	freezed = true
	$FreezeTimer.start(freeze_power)
	#freeze sprite

func _on_freeze_timer_timeout() -> void:
	freezed = false
	#normal sprite

func init_enemy_type(sprite_color: Color, hp: float, dmg: float) -> void:
	enemy_color_rect.color = sprite_color
	health = hp
	damage = dmg

func apply_knockback(direction: Vector2, force: float, duration: float) -> void:
	knockback = direction * force
	knockback_timer = duration

func enemy_is_hurted():
	print("call for help")
	if target == null:
		target = get_parent().get_node("Player")
