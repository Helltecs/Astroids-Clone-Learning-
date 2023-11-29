extends CanvasLayer

var lives

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = $LivesContainer.get_children()
	update_score(0)
	
	for child in get_children():
		child.show()
	for child in lives:
		child.show()
		
		
func update_score(score):
	$Score.text = str(score)


func _on_button_pressed():
	$Button.hide()
	emit_signal("start_game")
	
func hide_life(lives_left):
	lives[lives_left].hide()
	
