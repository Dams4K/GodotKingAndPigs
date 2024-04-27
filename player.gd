extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var side_movements = $SideMovements
@onready var jump: Jump = $Jump

func _ready():
	velocity = Vector2.ZERO
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	var is_moving = side_movements.is_moving
	var is_jumping = jump.is_jumping
	var is_falling = jump.is_falling
	animation_tree["parameters/conditions/is_idle"] = !is_moving and not is_jumping and not is_falling
	animation_tree["parameters/conditions/is_moving"] = is_moving and not is_jumping and not is_falling
	animation_tree["parameters/conditions/is_jumping"] = is_jumping
	animation_tree["parameters/conditions/is_falling"] = is_falling
	
	if side_movements.is_moving:
		animation_tree.set("parameters/Idle/blend_position", side_movements.direction)
		animation_tree.set("parameters/Run/blend_position", side_movements.direction)
		animation_tree.set("parameters/Jump/blend_position", side_movements.direction)
		animation_tree.set("parameters/Fall/blend_position", side_movements.direction)
