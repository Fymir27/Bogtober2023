extends HSlider

func _on_value_changed(value:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10 + value / 5);
	if (value == 0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true);
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false);
