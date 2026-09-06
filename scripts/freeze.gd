extends Node2D

var animation_time: float = 0.5

func _ready() -> void:
	$FreezeSound.play()
	$FreezeFX.emitting = true
	$Timer.start(animation_time)

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	$FreezeFX.emitting = false


func _on_freeze_fx_finished() -> void:
	queue_free()
