class_name StartleArea
extends Area2D

@export var timer : Timer
@export var scareAmount = 50


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		body.Startle(scareAmount)
