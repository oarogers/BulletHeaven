class_name GameOverMenu
extends MarginContainer

@onready var score_label: Label = %ScoreLabel
@onready var try_again_button: Button = %TryAgainButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	get_tree().paused = true
	try_again_button.pressed.connect(_on_Try_Again_Button_pressed)
	
	if OS.get_name() != "Web":
		%QuitButton.show()
		quit_button.pressed.connect(_on_Quit_Button_pressed)


func set_score_text(score: String) -> void:
	score_label.text = "Score: " + score


func _on_Try_Again_Button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Quit_Button_pressed() -> void:
	get_tree().quit()
