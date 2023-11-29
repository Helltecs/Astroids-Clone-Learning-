extends RigidBody2D

var rotation_speed = randf_range(-PI, PI)
var direction = Vector2.ZERO
var min_speed = 100.0
var max_speed = 200.0


signal destroyed

func _ready():
	pass

func _process(delta):
	rotation += rotation_speed * delta
	position += direction * randf_range(max_speed, min_speed) * delta
	#rotate(rotation_speed * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("shots"):
		emit_signal("destroyed", self)
		queue_free()

