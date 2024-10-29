class_name UpgradeInfo
extends Resource

enum Stat {
	MAX_HEALTH,
	BASE_DAMAGE,
	CURRENT_HEALTH,
}

@export_multiline var button_text: String
@export var stat_to_increase: Stat
@export var increase_amount: int

func apply_upgrade():
	pass
