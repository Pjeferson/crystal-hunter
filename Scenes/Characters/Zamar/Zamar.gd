extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

export (int) var direction = -1

var velocity = Vector2()
var is_dead = false
var is_dying = false

func _ready():
	scale.x = -direction

func _physics_process(delta):
	if is_dying:
		hideSprites()
		$Dying.visible = true
		$AnimationPlayer.play("Dying")
	elif is_dead:
		hideSprites()
		$Dead.visible = true
		$AnimationPlayer.play("Dead")
		$CollisionShape2D.disabled = true
	else:
		hideSprites()
		$Idle.visible = true
		$AnimationPlayer.play("Idle")
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)

func hideSprites():
	$Idle.visible = false
	$Dying.visible = false
	$Dead.visible = false

func _on_RichTextLabel_resume_game():
	is_dying = true
	$Timer.start()

func _on_Timer_timeout():
	is_dying = false
	is_dead = true
	print("dd")
