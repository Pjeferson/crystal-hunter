extends Area2D


signal catch_crystal (number)

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = true

func _on_Makai_give_crystal(number):
	$CollisionShape2D.disabled = false
	visible = true
	


func _on_Crystal_body_entered(body):
	if "Isa" in body.name:
		queue_free()
		emit_signal("catch_crystal", 3)