extends Node2D

@export var rotation_speed = PI * 0.75
@export var max_speed = 300.0
@export var acceleration = 5.0
@export var decceleration = 1.0

var speed = 0
var thrust_direction = Vector2.ZERO

var lives = 3
var view_rect

signal hit
signal dead
signal shoot

func _ready():
	view_rect = get_viewport_rect()
	set_process(false)
	
func _process(delta):
	var rotation_value = 0
	if Input.is_action_pressed("turn_right"):
		rotation_value = 1
	if Input.is_action_pressed("turn_left"):
		rotation_value = -1
	rotation += rotation_speed * rotation_value * delta
	
	if Input.is_action_pressed("accelerate"):
		thrust_direction = Vector2.UP.rotated(rotation)
		speed = move_toward(speed, max_speed, acceleration)
		position += thrust_direction * speed * delta
		$AnimatedPlayerSprite.play("accelerate")
		if not $ThrustSound.playing:
			$ThrustSound.play()
	else:
		speed = move_toward(speed, 0, acceleration)
		position += thrust_direction * speed * delta
		$AnimatedPlayerSprite.play("default")
		$AnimatedPlayerSprite.stop()
		$ThrustSound.stop()
		
	if Input.is_action_just_pressed("shoot"):
		$ShotSound.play()
		emit_signal("shoot")
	
	global_position.x = clamp(global_position.x, 0, view_rect.size.x)
	global_position.y = clamp(global_position.y, 0, view_rect.size.y)
	
	if lives <= 0:
		emit_signal("dead")
		$AnimatedPlayerSprite.play("default")
		$AnimatedPlayerSprite.stop()
		rotation = 0
	
func start(new_postition):
	position = new_postition
	show()
	await(get_tree().create_timer(1).timeout)
	$AnimatedPlayerSprite/Area2D/CollisionPolygon2D.set_deferred("disabled", false)
	
func _on_area_2d_area_entered(area):
	if not area.is_in_group("shots"):
		hide()
		lives -= 1
		$AnimatedPlayerSprite/Area2D/CollisionPolygon2D.set_deferred("disabled", true)
		emit_signal("hit")

