extends HSlider


func _ready():
	set_volume(value)
	value_changed.connect(set_volume)


func set_volume(linear: float):
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
