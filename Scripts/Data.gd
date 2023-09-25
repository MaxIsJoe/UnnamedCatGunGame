extends Node

var PlayerAmmo : int = 6
var player : Player
var score : int = 0

func AddPlayerAmmo(amount : int = 1) -> void:
	PlayerAmmo += amount
	UI.emit_signal("onAmmoChange", PlayerAmmo)

func ConsumePlayerAmmo() -> void:
	PlayerAmmo -= 1
	UI.emit_signal("onAmmoChange", PlayerAmmo)

func AddScore(amount : int) -> void:
	score += amount
	UI.emit_signal("onScoreChange", score)
