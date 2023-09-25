class_name Gun
extends CharacterBody2D

var raycastCount : int = 6
var onCooldown : bool = false
@export var RaycastHolder : Node2D
@export var StartleTemplate : PackedScene
@export var EnemyCarriesThis : bool = false
@export var fireCooldown : float = 0.2


func _ready() -> void:
	if(EnemyCarriesThis): raycastCount = $MuzzlePos/RaycastHolder.get_child_count()


func _input(event: InputEvent):
	if(EnemyCarriesThis): return
	look_at(get_global_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && onCooldown == false:
		shoot()


func shoot() -> void:
	if(onCooldown): return
	if(EnemyCarriesThis == false and Data.PlayerAmmo <= 0): return
	onCooldown = true
	for ray in pick_random_nodes():
		ray.Visualise()
	if(EnemyCarriesThis == false):
		for body in $MuzzlePos/PlayerHitbox.get_overlapping_bodies():
			if(body is Enemy):
				body.queue_free()
				Data.AddScore(200)
	if(EnemyCarriesThis == false): Data.ConsumePlayerAmmo()
	if(global_position.distance_to(Data.player.global_position) < 275):
		if(EnemyCarriesThis == false): 
			Data.player.Startle(100)
		else:
			Data.player.speed -= 200
	await get_tree().create_timer(fireCooldown).timeout
	onCooldown = false

func pick_random_nodes() -> Array[GunRay]:
	var childNodes = RaycastHolder.get_children()
	var randomNodes : Array[GunRay] = []
	for i in range(raycastCount):
		var randomIndex = randf_range(0, childNodes.size() - 1)
		var randomNode = childNodes[randomIndex]
		randomNodes.append(randomNode)
	return randomNodes
