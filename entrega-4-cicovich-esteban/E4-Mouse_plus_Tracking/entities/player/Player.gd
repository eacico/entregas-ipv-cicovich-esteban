extends Sprite

onready var cannon:Sprite = $Cannon

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (float) var FRICTION_WEIGHT:float = 0.1

var velocity:Vector2 = Vector2.ZERO
var projectile_container:Node


func set_projectile_container(container:Node):
	cannon.projectile_container = container
	projectile_container = container

func _physics_process(delta):
	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)
	
	if Input.is_action_just_pressed("fire"):
		if projectile_container == null:
			projectile_container = owner
			cannon.projectile_container = projectile_container
		cannon.fire()
	
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x , 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	position += velocity * delta
