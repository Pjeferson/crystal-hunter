extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP = -200
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = -1
var is_attacking = false

func _ready():
	pass

func _physics_process(delta):
	chooseDirection()
	
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
	print("acertou")

func hideSprites():
	$Idle.visible = false
	$Attack.visible = false
	$Move.visible = false
	$Jump.visible = false
	
func chooseDirection():
	if direction > 0:
		$Idle.flip_h = true
		$Attack.flip_h = true
		$Move.flip_h = true
		$Jump.flip_h = true
	else:
		$Idle.flip_h = false
		$Attack.flip_h = false
		$Move.flip_h = false
		$Jump.flip_h = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
