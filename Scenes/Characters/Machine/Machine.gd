extends KinematicBody2D

const SPEED = 120
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = -1
var is_attacking = false

func _ready():
	pass

func _physics_process(delta):
	chooseDirection()
	
	if direction == -1 and !is_attacking:
		hideSprites()
		$Move.visible = true
		velocity.x = -SPEED
	elif direction == 1 and !is_attacking:
		hideSprites()
		$Move.visible = true
		velocity.x = SPEED
	else:
		velocity.x = 0
		if !is_attacking:
			hideSprites()
			$Idle.visible = true
			$AnimationPlayer.play("Idle")
	if $RayCast2D.is_colliding() == true:
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if Input.is_action_just_pressed("ui_select") and !is_attacking and is_on_floor():
		is_attacking = true
		hideSprites()
		$Attack.visible = true
		$AnimationPlayer.play("Attack")
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
func hideSprites():
	$Idle.visible = false
	$Attack.visible = false
	$Move.visible = false
	
func chooseDirection():
	if direction > 0:
		$Idle.flip_h = true
		$Attack.flip_h = true
		$Move.flip_h = true
	else:
		$Idle.flip_h = false
		$Attack.flip_h = false
		$Move.flip_h = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
