class_name Jump
extends PlayerController

@export var direction = Vector2.UP: set = set_direction
@export var speed = 400.0

@export var jump: StringName = "ui_accept"
@export var coyote_time: float = 0.0

## At what velocity we say the player is falling
@export var falling_y_velocity := 0.0

@onready var coyote_timer: Timer = Timer.new()
var can_coyote = true

var is_jumping := false
var is_falling := false

func _ready():
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(on_cotoye_timer_timeout)
	add_child(coyote_timer)

func _physics_process(delta: float) -> void:
	var can_jump = player.is_on_floor()
	if can_jump:
		can_coyote = true
	else:
		can_jump = can_coyote
	
	if is_jumping:
		is_jumping = not player.is_on_floor()
	
	if can_jump:
		if Input.is_action_just_pressed(jump):
			is_jumping = true
			can_coyote = false
			player.velocity = direction * speed
		
	if not player.is_on_floor() and can_coyote and coyote_timer.is_stopped() and coyote_time > 0:
		coyote_timer.wait_time = coyote_time
		coyote_timer.start()
	
	is_falling = player.velocity.y > falling_y_velocity
	is_jumping = is_jumping and not is_falling

func set_direction(value: Vector2):
	direction = value

func on_cotoye_timer_timeout():
	can_coyote = false
