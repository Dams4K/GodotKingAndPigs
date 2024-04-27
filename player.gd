class_name Player
extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var side_movements = $SideMovements
@onready var jump: Jump = $Jump
@onready var attack_timer: Timer = $AttackTimer
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D

@export var is_attacking := false
@export var is_hit := false

func _ready():
	velocity = Vector2.ZERO
	animation_tree.active = true
	side_movements.direction = 1
	update_blend_position()


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		attack_timer.start()
	
	side_movements.can_move = not is_attacking
	
	var is_moving = side_movements.is_moving
	var is_jumping = jump.is_jumping
	var is_falling = jump.is_falling
	animation_tree["parameters/conditions/is_idle"] = not is_moving and not is_jumping and not is_falling and not is_attacking and not is_hit
	animation_tree["parameters/conditions/is_moving"] = is_moving and not is_jumping and not is_falling and not is_attacking and not is_hit
	animation_tree["parameters/conditions/is_attacking"] = is_attacking and not is_hit
	animation_tree["parameters/conditions/is_jumping"] = is_jumping and not is_attacking and not is_hit
	animation_tree["parameters/conditions/is_falling"] = is_falling and not is_attacking and not is_hit
	animation_tree["parameters/conditions/is_hit"] = is_hit
	
	if side_movements.is_moving:
		update_blend_position()


func update_blend_position():
	animation_tree.set("parameters/Idle/blend_position", side_movements.direction)
	animation_tree.set("parameters/Run/blend_position", side_movements.direction)
	animation_tree.set("parameters/Jump/blend_position", side_movements.direction)
	animation_tree.set("parameters/Fall/blend_position", side_movements.direction)
	animation_tree.set("parameters/Attack/blend_position", side_movements.direction)
	animation_tree.set("parameters/Hit/blend_position", side_movements.direction)

func _on_attack_timer_timeout() -> void:
	is_attacking = false
	collision_shape_2d.disabled = true #Just to be sure


func _on_hurt_box_ded() -> void:
	print_rich("[color=#ff0000]Player has died[/color]")
	hide()


func _on_hurt_box_damaged() -> void:
	print_rich("[color=#ffff00]The player has been damaged[/color]")
	is_hit = true
