extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func buddha_appear():
	$Player.can_move = false
	$BuddhaArrival.play()
	$AnimationPlayer.play("buddha_arrival")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("buddha_idle")
	$EndMusic.play()
	

func buddha_laser():
	$AnimationPlayer.play("buddha_laser")
	$LaserSound.play()
	$Laser.set_is_casting(true)
	$Laser2.set_is_casting(true)
	await get_tree().create_timer(2.0).timeout
	$BurningSound.play()
	$AnimationPlayer.play("player_burning")
	await $AnimationPlayer.animation_finished

func trigger_end():
	ChangeScene.change_scene(ChangeScene.death_menu)

func _on_end_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$DialogueActionable2D.action()
