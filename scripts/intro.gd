extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("intro_start")
	await $AnimationPlayer.animation_finished
	$DialogueActionable2D.action()
	#show_dialogue_balloon(load("res://dialogues/intro.dialogue"), "story")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		

func yeong_gi_appear():
	$AnimationPlayer.play("arrival")

func master_appear():
	$AnimationPlayer.play("master_arrival")
	await $AnimationPlayer.animation_finished

func master_departs():
		$AnimationPlayer.play("master_departure")

func test():
	print("LOOL")

func end_intro():
	ChangeScene.change_scene(ChangeScene.game_scene)
