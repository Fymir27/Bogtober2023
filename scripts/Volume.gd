extends HSlider

const SETTINGS_FILE = "user://settings.cfg"
const AUDIO_SECTION = "audio"
const VOLUME_KEY = "volume"

var config = ConfigFile.new()


func _ready():
	var err = config.load(SETTINGS_FILE)
	value = load_volume() if err == OK else 0.5
	set_volume(value)
	value_changed.connect(set_volume)
	drag_ended.connect(save_volume)


func set_volume(linear: float):
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)


func load_volume():
	return config.get_value(AUDIO_SECTION, VOLUME_KEY)


func save_volume(linear: float):
	config.set_value(AUDIO_SECTION, VOLUME_KEY, value)
	config.save(SETTINGS_FILE)
