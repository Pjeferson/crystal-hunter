extends RichTextLabel

signal stop_game ()
signal resume_game ()

var dialog = [
	"Zamar: Isa, não poderei continuar com você.",
	"Isa: Mas, Zamar, por que não?",
	"Isa: Zamar!!!"]
var page = 0

# Functions
func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	emit_signal("stop_game")

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		print(visible_characters)
		if visible_characters > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				bbcode_text = dialog[page]
				visible_characters = 0
			else:
				emit_signal("resume_game")
				get_parent().queue_free()
		else:
			visible_characters = get_total_character_count()

func _on_Timer_timeout():
	visible_characters = visible_characters + 1