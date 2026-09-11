extends CharacterBody2D


const SPEED = 70.0

var health: float = 150
var damage: float = 1
var min_x_position = 1440 
var max_x_position = 1780
var change_direction = false
var direction = Vector2(0,0)

var hit_area = "BossHitArea"

var dialog_unplayed = true # to tell if boss dialog has been played or not
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("lefthand")
	$AnimationPlayer.play("right_hand")
	$AnimationPlayer.play("head")
	$AnimationPlayer.play("rat")
	

func _start_fight() -> void:
	get_node(hit_area).name = "EnemyHitArea" #change name so that player takes damage
	hit_area = "EnemyHitArea"
	$MoveTimer.start()
	direction = Vector2(-1,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_move(delta)
	move_and_slide()
	


func take_damage(taked_damage: float) -> void:
	print("Boss take damage")
	health -= taked_damage
	print(health)
	# damage animation then :
	if health <= 0:
		# death animation then :
		queue_free()

func _move(delta: float) -> void:

	if change_direction:
		print("Timer expired:" + str($MoveTimer.wait_time))
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
	position += direction * SPEED * delta
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and dialog_unplayed:
		dialog_unplayed = false
		$DialogueActionable2D.action()

func play_boss_music() -> void:
	get_parent().get_node("AudioStreamBackground").stop()
	get_parent().get_node("AudioStreamFight").stop()
	get_parent().get_node("BossMusic").play()
	


func _on_move_timer_timeout() -> void:
	change_direction = true
