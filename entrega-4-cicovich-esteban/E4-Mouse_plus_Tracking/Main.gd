extends Node

onready var turretSpawnControl:Control = $TurretSpawnControl

export (PackedScene) var turret_scene:PackedScene

func _ready():
	var backround:TextureRect = $Background
	var player:Sprite = $Player
	var turretSpawnControl = $TurretSpawnControl
	randomize() #para que genere nuevas secuencias random
	player.set_projectile_container(self)
	
	spawn_andom_Turet(player)
	spawn_andom_Turet(player)
	spawn_andom_Turet(player)

func spawn_andom_Turet(target:Node2D):
	var turret_instance = turret_scene.instance()

	var turret_spawn_position = Vector2.ZERO
	turret_spawn_position.x = turretSpawnControl.rect_position.x + rand_range(0, turretSpawnControl.rect_size.x)
	turret_spawn_position.y = turretSpawnControl.rect_position.y + rand_range(0, turretSpawnControl.rect_size.y)
	turret_instance.position = turret_spawn_position

	add_child(turret_instance)
	turret_instance.set_values(target, self)
	
