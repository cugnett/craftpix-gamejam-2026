extends CanvasLayer

var player_health = 0
var hearth: PackedScene = preload("res://scenes/hearth.tscn")

var life_position = Vector2(30,30)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_player_health()
	_display_player_health()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_player_health() -> void:
	player_health = get_parent().get_node("Player").health
	
func _display_player_health() -> void:
	for i in range(1,player_health):
		var inst = hearth.instantiate()
		inst.position = life_position + i * Vector2(16,0) # inst.get_node("Sprite2D").texture.region.w
		add_child.call_deferred(inst)
	
func _update_display_player_health() -> void:
	pass



func _on_player_health_changed(value) -> void:
	print("Health changed : " + str(value))
	player_health += value
	_update_display_player_health()


func _on_player_player_is_in_room() -> void:
	pass # Replace with function body.
