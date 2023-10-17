extends Node2D

@export var rotation_speed_attack: float;
@export var rotation_speed_retract: float;

var idle_rotation: float;
var target_rotation: float;
var rotation_speed: float;
var attacking: bool;

func _ready():	
	$WeaponSprite/WeaponHitbox.monitoring = false;
	idle_rotation = rotation;

func _process(delta):
	
	if (!$WeaponSprite/WeaponAnimations.is_playing()):
		$WeaponSprite/WeaponHitbox.monitoring = false;
		target_rotation = idle_rotation;	
		rotation_speed = rotation_speed_retract;

	var diff = target_rotation - rotation;		
	var abs_diff = abs(diff);
	if (abs_diff < 0.01):
		return;
	var direction = diff / abs_diff;	
	var rotation_amount = direction * delta * rotation_speed;
	if (abs(rotation_amount) > abs_diff):
		rotation_amount = diff;
	rotate(rotation_amount);

func _on_enemy_hit(body: Node2D):	
	body.queue_free();	

func attack(point: Vector2):		
	var current_rotaion = rotation;
	look_at(point);
	target_rotation = rotation;	
	rotation_speed = rotation_speed_attack;
	rotation = current_rotaion;
	$WeaponSprite/WeaponHitbox.monitoring = true;
	$WeaponSprite/WeaponAnimations.play("stab");
	
		
