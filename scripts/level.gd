extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_player_change_camera_pos_x(player_pos_x) -> void:
	print(player_pos_x)
	$Camera2D.position.x = player_pos_x


func _on_player_change_camera_pos_y(player_pos_y) -> void:
	print(player_pos_y)
	$Camera2D.position.y = player_pos_y
