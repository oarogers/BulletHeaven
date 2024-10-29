class_name UpgradeMenu
extends MarginContainer

signal upgrade_selected(upgrade: String)

@export var upgrades: Array[UpgradeInfo]

func _on_button_pressed(upgrade: UpgradeInfo) -> void:
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	hide()


func _ready() -> void:
	for upgrade: UpgradeInfo in upgrades:
		var button = UpgradeButton.new()
		button.text = upgrade.button_text
		button.pressed.connect(_on_button_pressed.bind(upgrade))
		$HBoxContainer.add_child(button)
