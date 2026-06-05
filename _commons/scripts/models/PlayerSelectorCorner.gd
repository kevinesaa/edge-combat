class_name PlayerSelectorCorner

enum PlayerSelectorCornerEnum {
	TOP_LEFT = 0,
	TOP_RIGTH,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

class PlayerSelectorWrapper:
	
	var __confirmed:bool = false
	var __cornerId:PlayerSelectorCornerEnum
	var __playerType:PlayerTypeWrapper.PlayerType
	
	func _init(playerTypeId:int, cornerId:PlayerSelectorCornerEnum) -> void:
		self.__cornerId = cornerId
		self.__playerType = PlayerTypeWrapper.getById(playerTypeId)
	
	func getCornerId() -> PlayerSelectorCornerEnum:
		return self.__cornerId
	
	func getPlayerType() -> PlayerTypeWrapper.PlayerType:
		return self.__playerType
	
	func isConfirmed() -> bool:
		return self.__confirmed
	
	func setConfirmed(val:bool) -> void:
		self.__confirmed = val
