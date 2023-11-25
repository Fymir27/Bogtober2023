class_name UI extends CanvasLayer

signal quit_requested
signal restart_requested

@export var hp_bar: ProgressBar
@export var xp_bar: ProgressBar
@export var game_time: GameTime
@export var boss_progress: Range

@export var _player: Player
@export var _symbiosis_timer: Timer
@export var _item_icons: Array[Control]
@export var _game_over: Control
@export var _lvl_label: Label


func _ready():
	_game_over.hide()
	for icon in _item_icons:
		icon.hide()


func quit():
	quit_requested.emit()


func restart():
	restart_requested.emit()


func unlock_chain_lightning():
	_player.chain_lightning_unlocked = true
	_item_icons[0].visible = true
	$PickUpSound.play()


func unlock_symbiosis():
	_symbiosis_timer.start()
	_item_icons[1].visible = true
	$PickUpSound.play()


func unlock_speed():
	_player._speed += 500
	_item_icons[2].visible = true
	$PickUpSound.play()


func show_game_over_modal():
	_game_over.show()


func set_level(level):
	_lvl_label.text = str(level)
