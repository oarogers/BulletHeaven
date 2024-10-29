class_name SpawnManager
extends Node

enum ScreenSide {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

@export var enemy_scene: PackedScene
@export var enemy_data: EnemyData
@export var world: Node2D
@export var wave_duration: float = 60.0
@export var spawn_rate_curve: Curve
@export var enemies_per_wave_curve: Curve
@export var enemy_stat_growth_rate_curve: Curve

var max_num_of_waves: int = 16 # design goal: last 15 minutes max
var enemies_to_spawn: int = 0
var enemies_spawned: int = 0
var current_wave: int = 1
var elapsed_time := 0.0
var stat_growth_rate := 1.0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	start_wave()


func start_wave() -> void:
	enemies_to_spawn = get_enemy_count_for_wave(current_wave)
	stat_growth_rate = get_stat_growth_rate_for_wave(current_wave)
	enemies_spawned = 0
	elapsed_time = 0.0
	if enemies_to_spawn > 0:
		spawn_timer.start(wave_duration / enemies_to_spawn)


func _on_spawn_timer_timeout() -> void:
	if enemies_spawned < enemies_to_spawn:
		spawn_enemy(current_wave)
		enemies_spawned += 1
		elapsed_time += spawn_timer.wait_time
		update_spawn_rate()
	else:
		spawn_timer.stop()
		current_wave += 1
		start_wave()


func spawn_enemy(wave_num: int) -> void:
	var enemy_instance = enemy_scene.instantiate() as Enemy
	enemy_instance.position = get_random_offscreen_position()
	world.add_child(enemy_instance)
	enemy_instance.set_data(enemy_data, stat_growth_rate, wave_num)


func update_spawn_rate() -> void:
	elapsed_time = min(elapsed_time, wave_duration)
	var normalized_time = elapsed_time / wave_duration
	var spawn_time = spawn_rate_curve.sample(normalized_time)
	spawn_timer.wait_time = spawn_time


func get_enemy_count_for_wave(wave_num: int) -> int:
	var normalized_wave = float(wave_num) / float(max_num_of_waves)
	
	var num_of_enemies = enemies_per_wave_curve.sample(normalized_wave)
	
	return int(num_of_enemies)


func get_stat_growth_rate_for_wave(wave_num: int) -> float:
	var normalized_wave = float(wave_num) / float(max_num_of_waves)
	
	var stat_growth = enemy_stat_growth_rate_curve.sample(normalized_wave)
	
	return stat_growth


func get_random_offscreen_position() -> Vector2:
	var offset = 20.0
	var side = ScreenSide.values().pick_random()
	var position = Vector2()
	
	match side:
		ScreenSide.TOP:
			position.x = randf_range(Game.viewport_rect.position.x, Game.viewport_rect.position.x + Game.viewport_rect.size.x)
			position.y = Game.viewport_rect.position.y - offset
		ScreenSide.RIGHT:
			position.x = Game.viewport_rect.position.x + Game.viewport_rect.size.x + offset
			position.y = randf_range(Game.viewport_rect.position.y, Game.viewport_rect.position.y + Game.viewport_rect.size.y)
		ScreenSide.BOTTOM:
			position.x = randf_range(Game.viewport_rect.position.x, Game.viewport_rect.position.x + Game.viewport_rect.size.x)
			position.y = Game.viewport_rect.position.y + Game.viewport_rect.size.y + offset
		ScreenSide.LEFT:
			position.x = Game.viewport_rect.position.x - offset
			position.y = randf_range(Game.viewport_rect.position.y, Game.viewport_rect.position.y + Game.viewport_rect.size.y)
		
	return position
