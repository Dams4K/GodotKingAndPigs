class_name SideMovements
extends PlayerController

@export var MAX_SPEED = 300
@export var FRICTION = 1800
@export var ACCELERATION = 1600

@export var left: StringName = "ui_left"
@export var right: StringName = "ui_right"

var direction := 0.0
var is_moving := false

func _physics_process(delta: float) -> void:
	direction = Input.get_axis(left, right)
	if direction:
		is_moving = true
		player.velocity.x = move_toward(player.velocity.x, direction * MAX_SPEED, delta * ACCELERATION)
	else:
		is_moving = false
		player.velocity.x = move_toward(player.velocity.x, 0, FRICTION * delta)
