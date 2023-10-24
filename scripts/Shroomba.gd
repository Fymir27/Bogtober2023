extends Enemy

@export var _spores: Sprite2D;

var _original_speed: float;

func _ready():    
	$ChargeTimer.timeout.connect(explode);
	update_spores();

func _process(delta):    
	super._process(delta);
	update_spores();    

func _try_attack():
	if(!is_exploding()  && is_player_in_range()):
		_original_speed = _movement_speed;
		_movement_speed = 0;
		$ChargeTimer.start();

func is_exploding():
	return $ChargeTimer.time_left > 0;

func explosion_progress():
	return ($ChargeTimer.wait_time - $ChargeTimer.time_left) / $ChargeTimer.wait_time;

func is_player_in_range():
	return $AttackRange.overlaps_body(_target);

func explode():
	_movement_speed = _original_speed;
	$SporeParticles.emitting = true;
	if (is_player_in_range()):
		_target.deal_damage(_damage);

func update_spores():    
	if (is_exploding()):        
		var progress = explosion_progress();
		var eased = ease_in(progress);		
		_spores.modulate = Color(1, 1, 1, eased);                
	else:
		_spores.modulate = Color(1, 1, 1, 0);


func ease_in(x: float) -> float:    
	return 1 - sqrt(1 - pow(x, 2));
