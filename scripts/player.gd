extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	#get input for movement
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 200
	move_and_slide()
	
	#play animations for each side that it moves
	if velocity.length() > 0.0:
		if Input.is_action_pressed("move_down"):
			animated_sprite_2d.play("front_walk")
		if Input.is_action_pressed("move_up"):
			animated_sprite_2d.play("back_walk")
		if Input.is_action_pressed("move_left"):
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("side_walk")
		if Input.is_action_pressed("move_right"):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("side_walk")
	else:
		animated_sprite_2d.play("front_idle")
