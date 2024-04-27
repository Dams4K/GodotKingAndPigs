extends Node2D

var PIECE: PackedScene = preload("res://crate_piece.tscn")

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D


func _on_hurt_box_ded() -> void:
	collision_shape_2d.call_deferred("set_disabled", true)
	hide()
	for i in range(4):
		var piece = PIECE.instantiate()
		piece.global_position = global_position
		get_parent().call_deferred("add_child", piece)
	queue_free()
