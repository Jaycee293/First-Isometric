extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_my_hurt_box_area_entered(hitbox: Area2D) -> void:
		var base_damage = hitbox.damage
		print("hurt")
