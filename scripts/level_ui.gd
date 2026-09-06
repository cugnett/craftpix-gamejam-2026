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
	for i in range(0,player_health):
		var hearth = hearth.instantiate()
		hearth.position = life_position + i * Vector2(16,0) # inst.get_node("Sprite2D").texture.region.w
		add_child.call_deferred(hearth)
	
func _update_player_health(value) -> void:
	var old_player_health = player_health
	player_health += value
	
	var hearth_to_remove = old_player_health - player_health
	print("Remove:" + str(hearth_to_remove))
	print("for: " + str(old_player_health) + " to " + str(player_health))
	if hearth_to_remove > 0:
		for i in range(old_player_health, player_health, -1):
			print("REMOVE!" + str(i))
			if i > 0:
				get_child(i-1).queue_free()
	


func _on_player_health_changed(value) -> void:
	print("Health changed : " + str(value))
	_update_player_health(value)
