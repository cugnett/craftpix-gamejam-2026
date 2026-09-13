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

var room_boss = {"position": Vector2(3,-2), "done":true } #set boss room as already done
var room_end = {"position": Vector2(3,-3), "done":true } #set end room as already done
var room_list = [
	{"position": Vector2(0,0), "done":true }, #set base room as already done
	room_boss,
	room_end
	] 
var room_ramp = 1

var current_room = Vector2(0,1)

var enemies: Dictionary = {
	"easy_cultist": preload("res://ressources/easy_cultist.tres"),
	"medium_cultist": preload("res://ressources/medium_cultist.tres"),
	"hard_cultist": preload("res://ressources/hard_cultist.tres"),
}
var enemies_name = enemies.keys()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.boss_defeated.connect(_on_boss_defeated)


func _on_boss_defeated():
	instance_barrier.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Open room if all enemies have been killed
	if room_activated and enemy_nb == 0:
		room_ramp += 1
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
		var lucky = randi_range(0, 20)
		if lucky == 10:
			book_sheet_instance = book_sheet.instantiate()
			book_sheet_instance.position.x = current_player_map_position.x * camera_width + randi_range(48,camera_width-48)
			book_sheet_instance.position.y = current_player_map_position.y * camera_height + randi_range(48,camera_height-48)
			get_parent().add_child(book_sheet_instance)
			

func _activate_spawner(player_map_position: Vector2, player_position: Vector2) -> void:
	print("player pos" + str(player_map_position))
	_start_fight_music()
	var min_enemy_number = 1
	var max_enemy_number = room_ramp
	var max_enemy_type = 0 #easy
	if room_ramp == 1:
		max_enemy_type = 0
	if room_ramp >= 2:
		min_enemy_number = 2
		max_enemy_type = 1 #medium
	if room_ramp >= 4:
		max_enemy_type = 2 #hard
	if room_ramp >= 5:
		min_enemy_number = 3
		
		
	for i in randi_range(min_enemy_number,max_enemy_number):
		instance = enemy.instantiate()
		_init_stats_enemy(instance, _rand_enemy_type(max_enemy_type))
		enemy_nb += 1

		instance.position.x = player_map_position.x * camera_width + randi_range(48,camera_width-48)
		instance.position.y = player_map_position.y * camera_height + randi_range(48,camera_height-48)
		# Do not get too close to the player
		while instance.position.distance_to(player_position) < 120:
			instance.position.x = player_map_position.x * camera_width + randi_range(48,camera_width-48)
			instance.position.y = player_map_position.y * camera_height + randi_range(48,camera_height-48)
		print("enemy pos" + str(i) + ":"+ str(instance.position))
		instance.tree_exited.connect(on_enemy_exited)
		get_parent().add_child(instance)
	_set_room_barrier(player_map_position)
		

func _set_room_barrier(player_map_position):
	instance_barrier = barrier.instantiate()
	instance_barrier.position.x = player_map_position.x * camera_width
	instance_barrier.position.y = player_map_position.y * camera_height
	print("barrier pos" + str(instance_barrier.position))
	get_parent().add_child(instance_barrier)

func _rand_enemy_type(max_difficulty) -> EnemyRessource:
	var max_idx = max_difficulty
	print(enemies_name)
	#do not go higher than possible
	if max_difficulty > enemies_name.size() - 1:
		max_idx = enemies_name.size() - 1
	var enemy_index = randi_range(0, max_idx)
	return enemies[enemies_name[enemy_index]]

func _init_stats_enemy(enemy: Node2D,  enemy_type: EnemyRessource) -> void:
	enemy.get_node("AnimatedSprite2D").sprite_frames = enemy_type.animatedSprite
	enemy.get_node("AnimatedSprite2D").get_node("EnemyColorRect").color = enemy_type.color_sprite
	enemy.speed = enemy_type.speed
	enemy.health = enemy_type.health
	enemy.damage = enemy_type.damage

func _on_player_player_is_in_room(player_map_position, player_position) -> void:
	print("ACTIVATE!")
	current_room = player_map_position
	_add_to_room_list(current_room)
	print(str(room_list))
	print(str(_is_room_done(current_room)))
	if not _is_room_done(current_room):
		_activate_spawner(player_map_position, player_position)
		room_activated = true
		current_player_map_position = player_map_position
		_set_room_done(current_room)
	if current_room == room_boss["position"]:
		_set_room_barrier(player_map_position)
	
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

func _add_to_room_list(room_pos):
	# check if not already added
	for room in room_list:
		if room["position"] == room_pos:
			return
	room_list.append({"position":room_pos,"done":false})

func _set_room_done(room_pos):
	for room in room_list:
		if room["position"] == room_pos:
			room["done"] = true
			break
	
func _is_room_done(room_pos) -> bool:
	for room in room_list:
		if room["position"] == room_pos:
			if room["done"] == true:
				return true
	return false
