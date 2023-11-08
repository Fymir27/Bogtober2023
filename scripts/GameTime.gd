class_name GameTime extends Label

var total_seconds_elapsed: float = 0


func _process(delta):
	total_seconds_elapsed += delta
	var minutes = floori(total_seconds_elapsed / 60)
	var seconds = floori(total_seconds_elapsed) % 60
	text = "%02d:%02d" % [minutes, seconds]
