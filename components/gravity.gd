class_name Gravity
extends PlayerController

var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var gravity_scale := 1.0

func _physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += gravity_vector * gravity * gravity_scale * delta
