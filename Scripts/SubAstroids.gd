extends Node2D

var rotation_speed = randf_range(-PI, PI)
var direction = Vector2.ZERO
var min_speed = 100.0
var max_speed = 150.0

signal small_destroyed

func _ready():
	scale /= 2
	$Area2D/CollisionShape2D.disabled = true
	await (get_tree().create_timer(0.5).timeout)
	$Area2D/CollisionShape2D.disabled = false


func _process(delta):
	rotation += rotation_speed * delta
	position += direction * randf_range(max_speed, min_speed) * delta
	#rotate(rotation_speed * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("shots"):
		queue_free()
		emit_signal("small_destroyed")


func _on_clean_clutter_timeout():
	queue_free()
