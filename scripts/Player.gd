class_name Player extends CharacterBody2D

@export var _speed : float;
@export var _hp_bar : ProgressBar;
@export var _sprite : Sprite2D;

func _process(delta):
	handle_input();
	flip_sprite();

func _physics_process(delta):		
	move_and_slide();		
	
func handle_input():
	var direction = Vector2();
	if (Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)):
		direction.x = -1;
	if (Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)):
		direction.x =  1;
	if (Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W)):
		direction.y = -1;
	if (Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S)):
		direction.y =  1;
	var direction_norm = direction.normalized();
	velocity = direction_norm * _speed;
		
		
func flip_sprite():
	if (velocity.x > 0):
		_sprite.flip_h = true;	
	else: if (velocity.x < 0):
		_sprite.flip_h = false;

func deal_damage(amount: float):
	_hp_bar.value -= amount;
	
