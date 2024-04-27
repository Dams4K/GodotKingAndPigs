extends RigidBody2D

@export var SPEED := 10

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	randomize()
	
	var frame = randi_range(0, 4)
	sprite_2d.frame = frame
	
	linear_velocity.y = randf_range(0.4, 1) * SPEED
	linear_velocity.x = ([0, 2].pick_random() + -1) * randf_range(0.5, 1) * SPEED


func _on_timer_timeout() -> void:
	queue_free()
