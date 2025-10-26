class_name MyHitBox
extends Area2D

@export var damage := 14

func _on_body_entered(body: Node2D) -> void:
	body.has_method("take_damage")
	body.take_damage()
