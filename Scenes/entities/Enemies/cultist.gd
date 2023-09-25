class_name Enemy
extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var dazedEffect : AnimatedSprite2D
@export var enemyGun : Gun
@export var enemySight : RayCast2D
@export var fallTimeTillGetUp : float = 5
@export var hasGunOut : bool = false
@export var bulletAmmo : PackedScene
@export var speed : float = 1975

var hasFallen : bool = false
var wanderCooldown : bool = true
var wanderTo : Vector2 = Vector2.ZERO
var currentState : AiState = AiState.IDLE

enum AiState {
	IDLE,
	CHECK,
	ALERT,
	ATTACK,
}

func _ready() -> void:
	enemyGun.EnemyCarriesThis = true
	enemyGun.fireCooldown = 2.65
	if(hasGunOut): enemyGun.show()
	$WanderCooldown.start()
	
func _process(delta: float) -> void:
	if(Data.player == null or hasFallen): return
	enemySight.look_at(Data.player.global_position)
	if(enemySight.is_colliding() and currentState == AiState.IDLE and hasGunOut):
		EnterAttackState()
	if(currentState == AiState.ATTACK): 
		enemyGun.look_at(Data.player.global_position)
		enemyGun.shoot()
	else:
		enemyGun.rotation = 0
		velocity = Vector2.ZERO
	if(currentState == AiState.ALERT):
		if(enemySight.is_colliding()): EnterAttackState()
	
func _physics_process(delta: float) -> void:
	if(hasFallen): return
	if(currentState == AiState.ATTACK):
		velocity = global_position.direction_to(Data.player.global_position) * speed * delta
	if(currentState == AiState.IDLE and wanderCooldown == false):
		velocity = global_position.direction_to(wanderTo) * speed * delta
		if(global_position.distance_to(wanderTo) < 50):
			wanderTo = Vector2.ZERO
			wanderCooldown = true
			$WanderCooldown.start()
	move_and_slide()

func Fall():
	if(currentState == AiState.ATTACK):
		Data.player.Startle(150)
		Data.player.previousDirection = -Data.player.previousDirection
		return
	if(hasFallen): return
	Data.AddScore(15)
	hasFallen = true
	sprite.play("fall")
	$Collision.set_deferred("disabled", true)
	$AttackStateTimer.stop()
	var bullet = bulletAmmo.instantiate()
	bullet.position = position
	get_parent().call_deferred("add_child", bullet)
	enemyGun.hide()
	await sprite.animation_finished
	dazedEffect.show()
	await get_tree().create_timer(fallTimeTillGetUp).timeout
	sprite.play("Idle")
	$Collision.set_deferred("disabled", false)
	hasFallen = false
	if (hasGunOut): 
		enemyGun.show()
	else:
		hasGunOut = true
		enemyGun.show()
		currentState = AiState.ALERT
	dazedEffect.hide()
		
func EnterAttackState() -> void:
	currentState = AiState.ATTACK
	$AttackStateTimer.start()
	$alert.show()

func OnAttackStateTimerOut() -> void:
	enemySight.look_at(Data.player.global_position)
	if (enemySight.is_colliding()):
		$AttackStateTimer.start()
		return
	SetStateIdle()

func SetStateIdle() -> void:
	currentState = AiState.IDLE
	$alert.hide()


func _on_wander_cooldown_timeout() -> void:
	wanderCooldown = false
	wanderTo = Vector2(global_position.x + randf_range(-100, 100), global_position.y + randf_range(-100, 100))
