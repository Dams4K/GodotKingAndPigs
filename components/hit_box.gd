class_name HitBox
extends Area2D

@export var damages := 1.0


func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		(area as HurtBox).take_damages(damages)
