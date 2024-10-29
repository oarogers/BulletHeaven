class_name Hurtbox
extends Area2D

var health: HealthData

func take_damage(damage_amount: int):
	health.current_health -= damage_amount
