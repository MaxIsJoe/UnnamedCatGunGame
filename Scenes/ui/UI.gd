extends CanvasLayer

@export var speedBar: ProgressBar

signal onAmmoChange(score : int)
signal onScoreChange(score : int)

func UpdateSpeedBar(currentSpeed : float):
	speedBar.value = currentSpeed


func _on_on_ammo_change(score : int) -> void:
	$Screen/Amo.text = str("Ammo:" + str(score))


func _on_on_score_change(score) -> void:
	$Screen/sco.text = str("Ammo:" + str(score))
