extends Area2D

@export var speed = 100.0
var direction

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.get_parent().name != "AnimatedPlayerSprite" and not area.is_in_group("shots"):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
