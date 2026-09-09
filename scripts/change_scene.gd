extends CanvasLayer

const intro_scene = ("res://scenes/intro.tscn")
const game_scene = ("res://scenes/level1.tscn")
const death_menu = ("res://scenes/death_menu.tscn")
const end_scene = ("res://scenes/end_scene.tscn")

# Called when the node enters the scene tree for the first time.

func change_scene(scene_path):
	%AnimationPlayerChangeScene.play("fade")
	await %AnimationPlayerChangeScene.animation_finished
	get_tree().change_scene_to_file(scene_path)
	%AnimationPlayerChangeScene.play_backwards("fade")
