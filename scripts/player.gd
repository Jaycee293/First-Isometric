extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Sprite2D = $Attack
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var last_facing: String = "down" # "up", "down", "left", "right"

func _physics_process(delta: float) -> void:
	#get input for movement
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 200
	move_and_slide()
	
	#attack
	if Input.is_action_just_pressed("attack"):
		_do_attack()
		
	#play animations for each side that it moves
	if velocity.length() > 0.0:
		if Input.is_action_pressed("move_down"):
			animated_sprite_2d.play("front_walk")
			last_facing = "down"
		if Input.is_action_pressed("move_up"):
			animated_sprite_2d.play("back_walk")
			last_facing = "up"
		if Input.is_action_pressed("move_left"):
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("side_walk")
			last_facing = "left"
		if Input.is_action_pressed("move_right"):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("side_walk")
			last_facing = "right"
	else:
		match last_facing:
			"down":
				animated_sprite_2d.play("front_idle")
			"up":
				animated_sprite_2d.play("back_idle")
			"left":
				animated_sprite_2d.play("side_idle")
			"right":
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("side_idle")
		

func _do_attack(): 
	# Hide the regular sprite and show the attack sprite
	animated_sprite_2d.hide()
	attack.show()
	
	if velocity.length() > 0.0:
		match last_facing:
			"down":
				animation_player.play("front_attack")
			"up":
				animation_player.play("back_attack")
			"left":
				animation_player.play("left_attack")
			"right":
				animation_player.play("right_attack")
	else:
		animation_player.play("front_attack")
			
	await animation_player.animation_finished
	attack.hide()
	animated_sprite_2d.show()
