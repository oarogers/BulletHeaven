class_name Game
extends Node2D

@export var player_scene: PackedScene
@export var game_over_scene: PackedScene

static var player: Player
static var viewport_rect: Rect2

var camera: Camera2D
var survival_time: float = 0.0
var timer_active: bool = false

@onready var world: Node2D = $World
@onready var hud: CanvasLayer = $HUD
@onready var ui: CanvasLayer = $UI
@onready var spawn_manager: SpawnManager = $SpawnManager
@onready var upgrade_menu: UpgradeMenu = $UI/UpgradeMenu


func _ready() -> void:
	set_up_game()
	#spawn_player()
	#player.experience_data.leveled_up.connect(_on_player_leveled_up)
	#upgrade_menu.upgrade_selected.connect(_on_upgrade_selected)
	#spawn_manager.start_wave()
	#survival_time = 0.0
	#timer_active = true


func _process(delta: float) -> void:
	if timer_active:
		update_survival_time(delta)


func set_up_game() -> void:
	spawn_player()
	connect_signals()
	spawn_manager.start_wave()
	timer_active = true


func connect_signals() -> void:
	player.experience_data.leveled_up.connect(_on_player_leveled_up)
	upgrade_menu.upgrade_selected.connect(_on_upgrade_selected)


func update_survival_time(time: float) -> void:
	survival_time += time
	update_HUD_time(survival_time)


func update_HUD_time(time: float) -> void:
	$HUD.update_time_display(convert_time_to_string(time))
	

func convert_time_to_string(time: float) -> String:
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	return"%02d:%02d" % [minutes, seconds]


func spawn_player() -> void:
	player = player_scene.instantiate()	
	world.add_child(player)
	
	initialize_player_viewport()
	initialize_player_health()
	initialize_player_experience()


func initialize_player_viewport() -> void:
	viewport_rect = Rect2(player.camera_2d.get_screen_center_position() - (get_viewport_rect().size * player.camera_2d.zoom / 2),
		get_viewport_rect().size * player.camera_2d.zoom
	)


func initialize_player_health() -> void:
	player.health_data = HealthData.new(100)
	player.health_data.died.connect(_on_player_died)
	
	hud.health_bar.player_health_data = player.health_data
	player.health_data.health_updated.connect(hud.health_bar.on_health_updated)
	player.hurtbox.health = player.health_data
	hud.health_bar.force_update_health_display()

func initialize_player_experience() -> void:
	hud.experience_bar.player_experience_data = player.experience_data
	player.experience_data.experience_updated.connect(hud.experience_bar.on_experience_updated)


func _on_player_leveled_up(_new_level: int) -> void:
	pause_game.call_deferred()
	player.movement_direction = Vector2.ZERO
	upgrade_menu.show()


func pause_game() -> void:
	get_tree().paused = true


func _on_upgrade_selected(upgrade: UpgradeInfo) -> void:
	match upgrade.stat_to_increase:
		UpgradeInfo.Stat.MAX_HEALTH:
			player.health_data.max_health += upgrade.increase_amount
		UpgradeInfo.Stat.BASE_DAMAGE:
			player.damage += upgrade.increase_amount
		UpgradeInfo.Stat.CURRENT_HEALTH:
			player.health_data.current_health += upgrade.increase_amount


func _on_player_died() -> void:
	var game_over_instance = game_over_scene.instantiate() as GameOverMenu
	ui.add_child(game_over_instance)
	game_over_instance.set_score_text(convert_time_to_string(survival_time))
