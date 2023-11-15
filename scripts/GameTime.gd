class_name GameTime extends Label

var total_seconds_elapsed: float = 0
var difficulty: float = 0
var spawn_settings: SpawnSettings = preload("res://global/spawn_settings.tres")


func _process(delta):
	total_seconds_elapsed += delta
	var minutes = floori(total_seconds_elapsed / 60)
	var seconds = floori(total_seconds_elapsed) % 60
	text = "%02d:%02d" % [minutes, seconds]

	var difficulty_sample_pos = total_seconds_elapsed / spawn_settings.max_scaling_at_seconds
	difficulty = spawn_settings.sample_difficulty(difficulty_sample_pos)
	self_modulate = Color.WHITE.lerp(Color.RED, difficulty)
