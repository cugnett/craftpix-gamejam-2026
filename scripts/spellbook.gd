extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	SignalManager.booksheet_collected.connect(_on_book_sheet_booksheet_collected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_book_sheet_booksheet_collected() -> void:
	print("Collected!")
	#Set spell book position
	var player_position = get_parent().get_node("Player").player_map_position
	var camera_width = get_parent().get_node("Player").camera_width
	var camera_height = get_parent().get_node("Player").camera_height
	position = player_position * Vector2(camera_width,camera_height)
	position.x += camera_width/5
	position.y += camera_height/4.5
	
	#display spellbook
	$SpellBookSprite.get_child(0).visible = false
	visible = true
	$SpellBookSprite.play("open")
	await $SpellBookSprite.animation_finished
	$SpellBookSprite.get_child(0).visible = true
	
