class_name CombatStateMachine
extends Node2D


var s1:CombatMovement = ( 
	CombatMovementBuilder.new()
	.setInitMovement(CombatMovement.CombatState.IDLE_CENTER)
	.setMidMovement(CombatMovement.CombatState.PUNCH_RIGHT)
	.build()
)
