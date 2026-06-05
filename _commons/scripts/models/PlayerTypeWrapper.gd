class_name PlayerTypeWrapper

enum PlayerTypeEnum {
	PLAYER, CPU
}

class PlayerType:
	
	static var __idCounter:int = 0
	var __id:int
	
	var __type:PlayerTypeEnum
	var __number:int
	var __defaultText:String
	var __fullText:String
	
	func _init(type:PlayerTypeEnum,number:int, defultText:String) -> void:
		self.__id = self.__idCounter
		self.__number = number
		self.__defaultText = defultText
		self.__fullText = str(defultText,number)
		self.__idCounter = self.__idCounter + 1
	
	func getType() -> PlayerTypeEnum:
		return self.__type
	
	func getId() -> int:
		return self.__id
	
	func getText() -> String:
		return self.__defaultText
	
	func getNumber() -> int:
		return self.__number
	
	func getFullText() -> String:
		return self.__fullText
	
	func equals(other) -> bool:
		
		return (
			other != null
			and is_instance_of(other, PlayerType)
			and self.__id == other.__id
		)
		
		
static var PLAYER_ONE:PlayerType = PlayerType.new(PlayerTypeEnum.PLAYER,1,"P")
static var CPU_ONE:PlayerType = PlayerType.new(PlayerTypeEnum.CPU,1,"CPU")
