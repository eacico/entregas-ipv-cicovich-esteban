extends AbstractEnemyState

# Definimos variables para manejar el comportamiento de "caminata"
export (Vector2) var wander_radius: Vector2
export (float) var speed: float
export (float) var max_speed: float

## Con esta variable controlamos cuál es la distancia mínima para considerar
## que se llegó al "punto" deseado, y evitar situaciones de "dar vueltas"
## (esto se puede ver quitando el chequeo o seteandolo en 0.0)
export (float) var pathfinding_step_threshold: float = 5.0

# El path que definimos con el pathfinding
var path:Array = []


func enter() -> void:
	if character.pathfinding != null:
		var random_point:Vector2 = (
			character.global_position +
			Vector2(
				rand_range(-wander_radius.x, wander_radius.x),
				rand_range(-wander_radius.y, wander_radius.y)
			)
		)
		
		path = character.pathfinding.get_simple_path(
			character.global_position,
			random_point
		)
		
		if path.empty() || path.size() == 1:
			emit_signal("finished", "idle")
		else:
			if character.target != null:
				character._play_animation("walk_alert")
			else:
				character._play_animation("walk")
	else:
		emit_signal("finished", "idle")


func exit() -> void:
	path = []


func update(delta: float) -> void:
	if character._can_see_target():
		emit_signal("finished", "alert")
		return
	
	if path.empty():
		emit_signal("finished", "idle")
		return
	
	var next_point:Vector2 = path.front()
	
	while character.global_position.distance_to(next_point) < pathfinding_step_threshold:
		path.pop_front()
		
		if path.empty():
			emit_signal("finished", "idle")
			return
		
		next_point = path.front()
	
	character.velocity = (
		character.velocity +
		character.global_position.direction_to(next_point) * speed
	).clamped(max_speed)
	character._apply_movement()
	character.body_anim.flip_h =  character.velocity.x < 0


func _handle_body_entered(body: Node) -> void:
	._handle_body_entered(body)
	
	character._play_animation("alert")


func _handle_body_exited(body) -> void:
	._handle_body_exited(body)
	
	character._play_animation("go_normal")

func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"alert":
			character._play_animation("walk_alert")
		"go_normal":
			character._play_animation("walk")
