extends CharacterBody2D

@export var hp_max: int = 100
@export var hp: int = hp_max
@export var defense: int = 0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 200
	move_and_slide()
	
func die():
	queue_free()
