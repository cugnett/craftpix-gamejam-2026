extends Node2D

@export var spawner_map_position : Vector2 = Vector2(0,0)


var camera_width = 464#get_parent().get_node("Player").camera_width
var camera_height = 256#get_parent().get_node("Player").camera_height


var enemy = load("res://scenes/enemy.tscn")
var barrier = load("res://scenes/barrier.tscn")
var book_sheet = load("res://scenes/book_sheet.tscn")
var instance
var instance_barrier
var book_sheet_instance

var current_player_map_position: Vector2
var background_music_position: float # position in background music

var room_activated = false
var enemy_nb = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Open room if all enemies have been killed
	if room_activated and enemy_nb == 0:
		print("Victory!")
		_stop_fight_music()
		instance_barrier.queue_free()
		room_activated = false
		for i in randi_range(1,1):
			book_sheet_instance = book_sheet.instantiate()
			book_sheet_instance.position.x = current_player_map_position.x * camera_width + randi_range(48,camera_width-48)
			book_sheet_instance.position.y = current_player_map_position.y * camera_height + randi_range(48,camera_height-48)
			get_parent().add_child(book_sheet_instance)
			print(get_parent().name)
		var lucky = randi_range(0, 10)
		if lucky == 10:
			book_sheet_instance = book_sheet.instantiate()
			book_sheet_instance.position.x = current_player_map_position.x * camera_width + randi_range(48,camera_width-48)
			book_sheet_instance.position.y = current_player_map_position.y * camera_height + randi_range(48,camera_height-48)
			get_parent().add_child(book_sheet_instance)

func _activate_spawner(player_map_position: Vector2, player_position: Vector2) -> void:
	print("player pos" + str(player_map_position))
	_start_fight_music()
	for i in randi_range(1,4):
		instance = enemy.instantiate()
		enemy_nb += 1
		instance.position.x = player_map_position.x * camera_width + randi_range(48,camera_width-48)
		instance.position.y = player_map_position.y * camera_height + randi_range(48,camera_height-48)
		print("enemy pos" + str(i) + ":"+ str(instance.position))
		instance.tree_exited.connect(on_enemy_exited)
		get_parent().add_child(instance)
		
	instance_barrier = barrier.instantiate()
	instance_barrier.position.x = player_map_position.x * camera_width
	instance_barrier.position.y = player_map_position.y * camera_height
	print("barrier pos" + str(instance_barrier.position))
	get_parent().add_child(instance_barrier)
	print(enemy_nb)
	

func _on_player_player_is_in_room(player_map_position, player_position) -> void:
	print("ACTIVATE!")
	if not room_activated:
		_activate_spawner(player_map_position, player_position)
		room_activated = true
		current_player_map_position = player_map_position
	
func on_enemy_exited():
	enemy_nb -= 1
	print("enemy_nb :" + str(enemy_nb))
	
func _start_fight_music():
	# stop background
	background_music_position = get_parent().get_node("AudioStreamBackground").get_playback_position()
	get_parent().get_node("AudioStreamBackground").stop()
	#play door closed and wait 1 sec
	$DoorClose.play()
	await get_tree().create_timer(1).timeout
	# start fight music
	get_parent().get_node("AudioStreamFight").play()

func _stop_fight_music():
	get_parent().get_node("AudioStreamFight").stop()
	$DoorOpen.play()
	await get_tree().create_timer(1).timeout
	get_parent().get_node("AudioStreamBackground").play(background_music_position)
