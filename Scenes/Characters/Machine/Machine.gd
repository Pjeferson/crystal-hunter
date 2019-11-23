extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = -1
var is_attacking = false

func _ready():
	pass

func _physics_process(delta):
	chooseDirection()
	
	if !is_attacking:
		hideSprites()
		$Move.visible = true
		$AnimationPlayer.play("Move")
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
		
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding():
		#é player?
		is_attacking = true
		hideSprites()
		$Attack.visible = true
		$AnimationPlayer.play("Attack")
	
func hideSprites():
	$Idle.visible = false
	$Attack.visible = false
	$Move.visible = false
	$Dying.visible = false
	
func chooseDirection():
	if direction > 0:
		$Idle.flip_h = true
		$Attack.flip_h = true
		$Move.flip_h = true
		$Dying.flip_h = true
	else:
		$Idle.flip_h = false
		$Attack.flip_h = false
		$Move.flip_h = false
		$Dying.flip_h = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
