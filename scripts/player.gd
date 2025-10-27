extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Sprite2D = $Attack
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var last_facing: String = "down" # "up", "down", "left", "right"
var hp = 100.0
var is_alive = true
signal hp_zero

func _physics_process(delta: float) -> void:
	if is_alive :
		#get input for movement
		var direction = Input.get_vector("move_left","move_right","move_up","move_down")
		velocity = direction * 200
		move_and_slide()
		
		#attack
		if Input.is_action_just_pressed("attack_down"):
			_do_attack()
		if Input.is_action_just_pressed("attack_up"):
			_do_attack()
		if Input.is_action_just_pressed("attack_left"):
			_do_attack()
		if Input.is_action_just_pressed("attack_right"):
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
				
		#if player is not moving, play idle animations
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
		
		const DMG_RATE = 20.0			
		var overlapping_enem = %MyHurtBox.get_overlapping_bodies()
		if overlapping_enem.size() > 0 and is_alive:
			hp -= DMG_RATE * overlapping_enem.size() * delta
			%ProgressBar.value = hp
			animated_sprite_2d.hide()
			attack.show()
			animation_player.play("front_hurt")
			await animation_player.animation_finished
			attack.hide()
			animated_sprite_2d.show()
			if hp <= 0.0 : 
				die()
				hp_zero.emit()
				
	
	
func die():
	is_alive = false
	animated_sprite_2d.hide()
	attack.show()
	animation_player.play("death")
	await animation_player.animation_finished
	get_tree().paused = true

func _do_attack(): 
	# Hide the regular sprite and show the attack sprite
	
	animated_sprite_2d.hide()
	attack.show()
	
	if Input.is_action_just_pressed("attack_down"):
				animation_player.play("front_attack")
				last_facing = "down"
				
	if Input.is_action_just_pressed("attack_up"):
				animation_player.play("back_attack")
				last_facing = "up"
	
	if Input.is_action_just_pressed("attack_left"):
				animation_player.play("left_attack")
				last_facing = "left"
				
	if Input.is_action_just_pressed("attack_right"):
				animation_player.play("right_attack")
				last_facing = "right"

				
	await animation_player.animation_finished
	attack.hide()
	animated_sprite_2d.show()
	


func _on_hp_zero() -> void:
	%"Game over".visible = true
	
