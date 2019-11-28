extends KinematicBody2D

const SPEED = 30
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

signal give_crystal (number)

export (int) var hp = 100
export (int) var direction = -1

var velocity = Vector2()
var is_attacking = false
var is_dead = false
var atks = 0

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
				hideSprites()
				is_attacking = true
				if atks == 3:
					$Limit_Attack.visible = true
					$AnimationPlayer.play("Limit_Attack")
					$Limit_AttackFX.play()
					get_parent().get_node("ScreenShake").screen_shake(4, 9, 100)
					atks = 0
				else:
					$Attack.visible = true
					$AnimationPlayer.play("Attack")
					atks +=1

func get_hit(power):
	print ("acertou makai: "+ str(power))
	hp -= power
	if hp <= 0:
		is_dead = true
		emit_signal("give_crystal", 3)
	emit_signal("hp_change", hp)
	

func hideSprites():
	$Idle.visible = false
	$Attack.visible = false
	$Move.visible = false
	$Dying.visible = false
	$Jump.visible = false
	$Limit_Attack.visible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		if $RayCast2D.is_colliding():
			var object = $RayCast2D.get_collider()
			if "Isa" in object.get_name():
				object.get_hit(10)
		is_attacking = false
	elif anim_name == "Limit_Attack":
		if $RayCast2D2.is_colliding():
			var object = $RayCast2D2.get_collider()
			if "Isa" in object.get_name():
				object.get_hit(50)
		is_attacking = false