extends Area2D

func _ready() -> void:
	Animate()


func Animate():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	var randomX = randf_range(-30,30)
	tween.parallel().tween_property(self, "global_position", Vector2(global_position.x + randomX, global_position.y), 0.2)
	tween.parallel().tween_property(self, "global_position", Vector2(global_position.x, global_position.y - 20), 0.2)
	tween.play()
	await tween.finished
	tween.stop()
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y + 20), 0.2)
	tween.play()


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Data.AddPlayerAmmo()
		queue_free()
