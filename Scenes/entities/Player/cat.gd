class_name Player
extends CharacterBody2D

@export var startingSpeed : float = 700.0
@export var maxSpeed : float = 1200.0
@export var sprites : AnimatedSprite2D
@export var runParticles : CPUParticles2D
@export var gun : Gun

@export_category("Position Markers")
@export var runParticleLeftPostion : Marker2D
@export var runParticleRightPostion : Marker2D
@export var gunRightPostion : Marker2D
@export var gunLeftPostion : Marker2D

var speed : float = 300.0
var previousDirection : Vector2 = Vector2(0,0)


func _ready() -> void:
	speed = startingSpeed
	sprites.frame = 1
	sprites.play("run")
	UI.speedBar.max_value = maxSpeed
	UI.emit_signal("onAmmoChange", Data.PlayerAmmo)
	Data.player = self


func _physics_process(delta: float) -> void:
	speed = clamp(speed - 9.75 * delta, 0, maxSpeed)
	UI.UpdateSpeedBar(speed)
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * speed
		previousDirection = direction
		if(direction.x > 0):
			sprites.flip_h = true
			runParticles.position = runParticleRightPostion.position
			var newGrav = runParticles.gravity
			newGrav.x = -1600
			runParticles.gravity = newGrav
			gun.position = gunLeftPostion.position
		else:
			sprites.flip_h = false
			runParticles.position = runParticleLeftPostion.position
			var newGrav = runParticles.gravity
			newGrav.x = 1600
			runParticles.gravity = newGrav
			gun.position = gunRightPostion.position
	else:
		velocity = previousDirection * speed
		
	if(speed <= 0):
		set_physics_process(false)
		#Lootlocker._upload_score(Data.score)

	move_and_slide()

func Startle(strengthOfScare: float) -> void:
	speed += strengthOfScare

func damage():
	speed -= 600
	print(speed)


func _on_hit_enter_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Enemy")):
		body.Fall()
