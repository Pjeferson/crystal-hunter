extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

export (int) var hp = 50
export (int) var direction = -1

var velocity = Vector2()
var is_attacking = false
var is_dead = false

func _ready():
	scale.x = -direction

func _physics_process(delta):
	if is_dead:
		hideSprites()	
		$Dying.visible = true
		$AnimationPlayer.play("Dying")
		$CollisionPolygon2D.disabled = true
	else:
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
			scale.x *= -1
		
		if $RayCast2D.is_colliding() && !is_attacking:
			var object = $RayCast2D.get_collider()
			if "Isa" in object.get_name():
				is_attacking = true
				hideSprites()
				$Attack.visible = true
				$AnimationPlayer.play("Attack")
	
func get_hit(power):
	print ("acertou machine: "+ str(power))
	hp -= power
	if hp <= 0:
		is_dead = true
	emit_signal("hp_change", hp)

func hideSprites():
	$Idle.visible = false
	$Attack.visible = false
	$Move.visible = false
	$Dying.visible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		is_attacking = false
		if $RayCast2D.is_colliding():
			var object = $RayCast2D.get_collider()
			if "Isa" in object.get_name():
				object.get_hit(10)
				
