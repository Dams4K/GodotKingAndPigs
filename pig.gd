extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var ray_cast_2d: RayCast2D = $Eyes/RayCast2D
@onready var forget_timer: Timer = $ForgetTimer

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var MAX_SPEED = 300
@export var FRICTION = 1800
@export var ACCELERATION = 1600

var direction: float = 1
var can_attack := false

@export var is_attacking := false
@export var is_hit := false
var is_idle := true
var is_moving := false

var follow_player := false

var player: Player

func _ready() -> void:
	update_blend_position()

func _physics_process(delta: float) -> void:
	animation_tree.active = true
	
	if can_attack and not is_attacking:
		# Make the pig attack the player
		is_attacking = true
	
	if player:
		if player.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1
	
		update_blend_position()
	
	animation_tree["parameters/conditions/is_idle"] = not is_moving and not is_attacking and not is_hit
	animation_tree["parameters/conditions/is_moving"] = is_moving and not is_attacking and not is_hit
	animation_tree["parameters/conditions/is_attacking"] = is_attacking and not is_hit
	animation_tree["parameters/conditions/is_hit"] = is_hit
	
	
	if player:
		# The player is in the view of the pig, now we use a ray to know if the pig can really see the player. We do not want the pig to be able to see the player hiding behind a wall
		ray_cast_2d.look_at(player.global_position)
		if ray_cast_2d.get_collider() is Player:
			# The player return in the view of the pig, no need to forget
			if not forget_timer.is_stopped():
				forget_timer.stop()
			
			# Now, the pig will follow the player
			follow_player = true
	
	# Movements
	if follow_player and player:
		navigation_agent_2d.target_position = player.global_position
		var d = navigation_agent_2d.get_next_path_position() - global_position
		d = d.normalized()
		
		is_moving = d.x != 0
		
		if is_on_floor() and player.global_position.y+32 < global_position.y:
			velocity.y = -300 # JUMP
		else:
			velocity.x = move_toward(velocity.x, d.x * MAX_SPEED, ACCELERATION * delta)
		
		move_and_slide()

func update_blend_position():
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Attack/blend_position", direction)
	animation_tree.set("parameters/Run/blend_position", direction)
	animation_tree.set("parameters/Hit/blend_position", direction)

func _on_view_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	player = body


func _on_view_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	forget_timer.start()


func _on_forget_timer_timeout() -> void:
	# The pig stops following the player
	follow_player = false


func _on_attack_range_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	can_attack = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	player = body
	
	can_attack = false


func _on_hurt_box_ded() -> void:
	print_debug("%s is ded" % name)
	queue_free()


func _on_hurt_box_damaged() -> void:
	is_hit = true
