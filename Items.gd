extends HBoxContainer

@export var player : Player;
@export var symbiosis_timer: Timer;
@export var icons : Array[TextureRect]

func unlock_chain_lightning():
	player.chain_lightning_unlocked = true;
	icons[0].visible = true;
	$PickUpSound.play();

func unlock_symbiosis():
	symbiosis_timer.start();
	icons[1].visible = true;
	$PickUpSound.play();

func unlock_speed():
	player._speed += 500;
	icons[2].visible = true;
	$PickUpSound.play();
