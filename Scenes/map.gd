extends Node2D

@export var enemies : Node2D
@export var enemyPrefab : PackedScene




func _on_spawn_timer_timeout() -> void:
	if(enemies.get_child_count() > 75): return
	var newEnemy = enemyPrefab.instantiate()
	newEnemy.position = $SpawnPositions.get_child(randf_range(0, $SpawnPositions.get_child_count() - 1)).position
	enemies.add_child(newEnemy)
