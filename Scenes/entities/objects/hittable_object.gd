extends CharacterBody2D

@export var resetTimer : Timer
@export var sprites : AnimatedSprite2D
@export var scoreToGive : int = 5
@export var scareAmount : float = 5

var isDown : bool = false

func RunInto() -> void:
	if(isDown): return
	resetTimer.start()
	sprites.play("falling")
	isDown = true
	$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _on_reset_timer_timeout() -> void:
	sprites.play("idle")
	isDown = false
	$Area2D/CollisionShape2D.set_deferred("disabled", false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(isDown): return
	if(body is Player):
		RunInto()
		body.Startle(scareAmount)
		Data.AddScore(scoreToGive)
