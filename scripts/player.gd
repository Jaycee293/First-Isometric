extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Sprite2D = $Attack
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dash: Node2D = $Dash



var last_facing: String = "down" # "up", "down", "left", "right"

var hp = 100.0
var is_alive = true
signal hp_zero

const SPEED = 200.0
const DASH_SPEED = 700.0
const DASH_DUR = 0.2


func _physics_process(delta: float) -> void:
	if is_alive :
		#get input for movement
		var direction := Vector2.ZERO
		direction.x = Input.get_axis("move_left", "move_right")
		direction.y = Input.get_axis("move_up", "move_down")
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(DASH_DUR)
			#animated_sprite_2d.hide()
			#attack.show()
			#dashing = true
			#can_dash = false
			#match last_facing:
				#"left":
					#attack.flip_h = false
					#animation_player.play("dash")
				#"right":
					#attack.flip_h = true
					#animation_player.play("dash")
			#
			#dashing = true
			#can_dash = false
			#
			#await animation_player.animation_finished
			#attack.hide()
			#
			#animated_sprite_2d.show()
			#
		#
			#
			#$dash_timer.start()
			#$cooldown_dash.start()
			
		var speed = DASH_SPEED if dash.is_dashing() else SPEED
		
		if direction:
			# 1. NORMALIZAÇÃO: Garante que a magnitude do vetor seja 1,
			# eliminando o aumento de velocidade nas diagonais.
			# 2. APLICAÇÃO: Multiplica o vetor normalizado pela velocidade constante
			velocity = direction.normalized() * speed
			#if dashing:
				#velocity = direction.normalized() * DASH_SPEED
		else:
			velocity = Vector2.ZERO
	
		set_animation(direction)
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
				
func set_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		# se ta andando horizontalmente
		if direction.x != 0:
			animated_sprite_2d.play("side_walk")
			if direction.x < 0:
				animated_sprite_2d.flip_h = true # Esquerda
				last_facing = "left"
			else:
				animated_sprite_2d.flip_h = false # Direita
				last_facing = "right"
		# se ta andando verticalmente
		elif direction.y != 0:
			if direction.y < 0:
				animated_sprite_2d.play("back_walk") # Cima
				last_facing = "up"
			else:
				animated_sprite_2d.play("front_walk") # Baixo
				last_facing = "down"
	else:
		match last_facing:
			"down":
				animated_sprite_2d.play("front_idle")
			"up":
				animated_sprite_2d.play("back_idle")
			"left":
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.play("side_idle")
			"right":
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("side_idle")
				
#func _on_dash_timer_timeout() -> void:
	#dashing = false
#
#
#func _on_cooldown_dash_timeout() -> void:
	#can_dash = true

	
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
				
	if Input.is_action_just_pressed("attack_up"):
				animation_player.play("back_attack")
	
	if Input.is_action_just_pressed("attack_left"):
				animation_player.play("left_attack")
				
	if Input.is_action_just_pressed("attack_right"):
				animation_player.play("right_attack")

				
	await animation_player.animation_finished
	attack.hide()
	animated_sprite_2d.show()
	


func _on_hp_zero() -> void:
	%"Game over".visible = true
	
