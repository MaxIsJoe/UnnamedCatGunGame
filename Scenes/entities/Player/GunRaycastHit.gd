class_name GunRay
extends RayCast2D

@export var line : Line2D

func _ready() -> void:
	exclude_parent = true
	

func Visualise() -> void:
	enabled = true
	await get_tree().process_frame
	line.width = 1.5
	line.add_point(position)
	line.add_point(target_position)
	queue_redraw()
	var callable = Callable(self, "Clear")
	get_tree().create_timer(0.12).timeout.connect(callable)

func Clear():
	enabled = false
	line.clear_points()
	queue_redraw()
