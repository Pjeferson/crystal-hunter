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

func _ready():
	emit_signal("hp_change", hp)

func _physics_process(delta):
	chooseDirection()
	if is_dead:
		hideSprites()
		$Dying.visible = true
	else:
		if Input.is_action_pressed("ui_left") and !is_attacking:
			direction = -1
			hideSprites()
			$Move.visible = true
			velocity.x = -SPEED
		elif Input.is_action_pressed("ui_right") and !is_attacking:
			direction = 1
			hideSprites()
			$Move.visible = true
			velocity.x = SPEED
		else:
			velocity.x = 0
			if !is_attacking:
				hideSprites()
				$Idle.visible = true
				$AnimationPlayer.play("Idle")
		
		if Input.is_action_pressed("ui_up") and !is_attacking and is_on_floor():
			velocity.y = JUMP
		
		if Input.is_action_just_pressed("ui_select") and !is_attacking and is_on_floor():
			is_attacking = true
			hideSprites()
			$Attack.visible = true
			$AnimationPlayer.play("Attack")
		
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
	
func chooseDirection():
	if direction > 0:
		$Idle.flip_h = true
		$Attack.flip_h = true
		$Move.flip_h = true
		$Jump.flip_h = true
		$Dying.flip_h = true
		$RayCast2D.cast_to.x = abs($RayCast2D.cast_to.x) 
	else:
		$Idle.flip_h = false
		$Attack.flip_h = false
		$Move.flip_h = false
		$Jump.flip_h = false
		$Dying.flip_h = false
		$RayCast2D.cast_to.x = abs($RayCast2D.cast_to.x) * -1 		

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
		if $RayCast2D.is_colliding():
			var object = $RayCast2D.get_collider()
			if "Makai" in object.get_name() or "Machine" in object.get_name():
				object.get_hit(20)


func _on_Timer_timeout():
	#get_tree().change_scene("res://Menu.tscn")
	get_tree().change_scene("res://Scenes/Scenarios/StageCastle.tscn")