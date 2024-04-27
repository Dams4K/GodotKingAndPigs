class_name HurtBox
extends Area2D

signal ded

@export var MAX_HEALTH := 5.0
@onready var health = MAX_HEALTH

func take_damages(damages: float):
	health -= damages
	if health <= 0:
		ded.emit()
