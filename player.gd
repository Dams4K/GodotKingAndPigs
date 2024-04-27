extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var side_movements = $SideMovements

func _ready():
	animation_tree.active = true
	
	set_physics_process(false)
	await get_tree().create_timer(0.5).timeout
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	var is_moving = side_movements.is_moving
	animation_tree["parameters/conditions/is_idle"] = !is_moving
	animation_tree["parameters/conditions/is_moving"] = is_moving
	
	if side_movements.is_moving:
		animation_tree.set("parameters/Idle/blend_position", side_movements.direction)
		animation_tree.set("parameters/Run/blend_position", side_movements.direction)
