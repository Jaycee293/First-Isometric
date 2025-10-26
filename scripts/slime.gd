extends CharacterBody2D

var health = 2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = $"../Player"

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 20
	move_and_slide()
	
func take_damage():
	health -= 1
	print("hurt")
	if health == 0:
		queue_free()
