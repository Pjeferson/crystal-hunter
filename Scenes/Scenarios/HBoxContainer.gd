extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Isa_hp_change(hp):
	$MarginContainer/NinePatchRect/Label.text = str(hp)
	$TextureProgress.value = hp

func _on_Crystal_catch_crystal(number):
	if number == 1:
		$Crystal1.visible = true
	elif number == 2:
		$Crystal2.visible = true	
	elif number ==3:
		$Crystal3.visible = true
	