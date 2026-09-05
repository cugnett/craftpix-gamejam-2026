extends Node2D

var animation_time: float = 1

func _ready() -> void:
	$ExplosionFX.emitting = true
	$Timer.start(animation_time)

func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$ExplosionFX.emitting = false

func _on_explosion_fx_finished() -> void:
	queue_free()
