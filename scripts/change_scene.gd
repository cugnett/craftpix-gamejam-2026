extends CanvasLayer

const game_scene = ("res://scenes/level1.tscn")
# Called when the node enters the scene tree for the first time.

func change_scene(scene_path):
	%AnimationPlayerChangeScene.play("fade")
	await %AnimationPlayerChangeScene.animation_finished
	get_tree().change_scene_to_file(scene_path)
	%AnimationPlayerChangeScene.play_backwards("fade")
