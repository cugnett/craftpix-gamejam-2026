extends Node2D

@export var spawner_map_position : Vector2 = Vector2(0,0)


var camera_width = 464#get_parent().get_node("Player").camera_width
var camera_height = 256#get_parent().get_node("Player").camera_height

var enemy = load("res://scenes/enemy.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _activate_spawner(player_map_position: Vector2, player_position: Vector2) -> void:
	print("player pos" + str(player_map_position))
	for i in randi_range(1,4):
		instance = enemy.instantiate()
		instance.position.x = player_map_position.x * camera_width + randi_range(48,camera_width-48)
		instance.position.y = player_map_position.y * camera_height + randi_range(48,camera_height-48)
		print("enemy pos" + str(i) + ":"+ str(instance.position))
		get_parent().add_child(instance)


func _on_player_player_is_in_room(player_map_position, player_position) -> void:
	print("ACTIVATE!")
	_activate_spawner(player_map_position, player_position)
