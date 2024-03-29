extends KinematicBody2D

const SPEED = 70
const GRAVITY = 10
const JUMP = -250
const FLOOR = Vector2(0,-1)

signal hp_change (hp)

export (int) var hp = 100
export (int) var direction = -1

var velocity = Vector2()
var is_attacking = false
var is_dead = false
var last_direction
var is_stop = false

func _ready():
	$Castle.play()
	emit_signal("hp_change", hp)
	scale.x = -direction
	last_direction= direction

func _physics_process(delta):
	if is_dead:
		hideSprites()
		$Dying.visible = true
	else:
		if Input.is_action_pressed("ui_left") and !is_attacking and !is_stop:
			direction = -1
			if(last_direction != direction):
				scale.x *= -1
				last_direction = -1
			hideSprites()
			$Move.visible = true
			$AnimationPlayer.play("Move")
			velocity.x = -SPEED
		elif Input.is_action_pressed("ui_right") and !is_attacking and !is_stop:
			direction = 1
			if(last_direction != direction):
				scale.x *= -1
				last_direction = 1
			hideSprites()
			$Move.visible = true
			$AnimationPlayer.play("Move")
			velocity.x = SPEED
		else:
			velocity.x = 0
			if !is_attacking:
				hideSprites()
				$Idle.visible = true
				$AnimationPlayer.play("Idle")
			
		if Input.is_action_pressed("ui_up") and !is_attacking and is_on_floor() and !is_stop:
			velocity.y = JUMP
		
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().change_scene("res://Scenes/Utilities/MenuPause.tscn")
		
		
		if Input.is_action_just_pressed("ui_select") and !is_attacking and is_on_floor() and !is_stop:
			is_attacking = true
			hideSprites()
			$Attack.visible = true
			$AnimationPlayer.play("Attack")
			$AttackFx.play()
			$TimerAttack.start()
		
		if !is_on_floor() && !is_attacking:
			hideSprites()
			$Jump.visible = true
			$AnimationPlayer.play("Jump")
		
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)

func get_hit(power):
	print("acertou: " + str(power))
	hp -= power
	if hp <= 0:
		is_dead = true
		$Castle.stop()
		$Boss.stop()
		$LoseFx.play()
		$Timer.start()
	emit_signal("hp_change", hp)

func fill():
	hp = 100
	emit_signal("hp_change", hp)
		
func hideSprites():
	$Idle.visible = false
	$Attack.visible = false
	$Move.visible = false
	$Jump.visible = false
	$Dying.visible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
		if $RayCast2D.is_colliding():
			var object = $RayCast2D.get_collider()
			if "Makai" in object.get_name() or "Machine" in object.get_name():
				object.get_hit(20)

func _on_Timer_timeout():
	$LoseFx.stop()
	print("!!")
	get_tree().change_scene("res://Scenes/Utilities/MenuPause.tscn")

func _on_Crystal_catch_crystal(number):
	$Castle.stop()
	$Boss.stop()
	$WinFx.play()

func _on_Collider_body_entered(body):
	$Castle.stop()
	$Boss.play()


func _on_TimerAttack_timeout():
	$AttackFx.play()


func _on_RichTextLabel_stop_game():
	is_stop = true


func _on_RichTextLabel_resume_game():
	is_stop = false