extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func buddha_appear():
	$BuddhaArrival.play()
	$AnimationPlayer.play("buddha_arrival")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("buddha_idle")
	$EndMusic.play()
	

func buddha_laser():
	$Laser.set_is_casting(true)
	$Laser2.set_is_casting(true)


func _on_end_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$DialogueActionable2D.action()
