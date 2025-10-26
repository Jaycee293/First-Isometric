extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func take_damage(amount: int) -> void:
	animation_player.play("hurt")
