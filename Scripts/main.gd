extends Node

@export var astroid_scene : PackedScene
@export var shot_scene: PackedScene

var score = 0
var difficulty = 1

var sub_astroid_scene = preload("res://Scenes/SubAstroids.tscn")

func _ready():
	randomize()


func _on_spawn_timer_timeout():
	$Path2D/PathFollow2D.set_progress_ratio(randf_range(0, 1))
	var astroid = astroid_scene.instantiate()
	$EnemyContainer.add_child(astroid)
	
	astroid.position = $Path2D/PathFollow2D.position
	
	if $Path2D/PathFollow2D.progress_ratio < 0.25:
		astroid.direction = Vector2(randf_range(-0.5, 0.5), 1) 
			
	elif $Path2D/PathFollow2D.progress_ratio > 0.25 and $Path2D/PathFollow2D.progress_ratio < 0.5:
		astroid.direction = Vector2(-1, randf_range(-0.5, 0.5)) 
		
	elif $Path2D/PathFollow2D.progress_ratio > 0.5 and $Path2D/PathFollow2D.progress_ratio < 0.75:
		astroid.direction = Vector2(randf_range(-0.5, 0.5), -1) 
		
	else:
		astroid.direction = Vector2(1, randf_range(-0.5, 0.5)) 
		
	astroid.connect("destroyed", _on_astroid_destroyed)


func _on_player_hit():
	$Player.start($Marker2D.position)
	$HUD.hide_life($Player.lives)


func _on_hud_start_game():
	$Player.lives = 3
	$Player.start($Marker2D.position)
	$Player.set_process(true)
	$SpawnTimer.start()
	$DifficultyTimer.start()
	$Music.play()
	$Ambient.play()


func _on_player_dead():
	$SpawnTimer.stop()
	$SpawnTimer.wait_time = 1.5
	$DifficultyTimer.stop()
	$Player.set_process(false)
	$HUD._ready()
	get_tree().call_group("astroids", "queue_free")
	$Music.stop()
	$Ambient.stop()
	$Player/ThrustSound.stop()


func _on_player_shoot():
	var shot = shot_scene.instantiate()
	add_child(shot)
	shot.rotation = $Player/Muzzle.global_rotation
	shot.position = $Player/Muzzle.global_position
	shot.direction = Vector2(sin(shot.rotation), -cos(shot.rotation))


func _on_music_finished():
	$Music.play()


func _on_ambient_finished():
	$Ambient.play()
	
	
func _on_astroid_destroyed(parent):
		for n in range(3):
			call_deferred("spawn_smaller_astroids", parent)
		score += 100
		$HUD.update_score(score)
	
	
func _on_small_astroid_destroyed():
	score += 150
	$HUD.update_score(score)
	
func spawn_smaller_astroids(parent):
	var astroid  = sub_astroid_scene.instantiate()
	astroid.position = parent.position
	astroid.direction = Vector2(randf_range(parent.direction.x * -0.5, parent.direction.x * 1.5), 
	randf_range(parent.direction.y * -0.5, parent.direction.y * 1.5))
	get_parent().add_child(astroid)
	astroid.connect("small_destroyed", _on_small_astroid_destroyed)



func _on_difficulty_timer_timeout():
	difficulty += 1
	$SpawnTimer.wait_time /= difficulty

