extends Node

#Player Stats
var Global_PlayerHP = 20
var Global_PlayerMana = 100
var Global_PlayerStamina = 100
var Global_PlayerStrength = 1

#Player movement
var Global_PlayerSpeed = 180
var Global_PlayerDirection = "Down"
var Global_PlayerPosition = Vector2(0,0)

#Player Armor and Sprites
var Global_PlayerHead_Armor
var Global_PlayerChest_Armor
var Global_PlayerLegs_Armor
var Global_PlayerCharacter
var Global_PlayerIcon

#Player Weapon
var Global_Ammo = 0
var Global_CurrentWeaponDirection = "Down"
var Global_CurrentWeaponPosition = Vector2(0,0)
var Global_CurrentWeaponNode = null

#Player Current Map
var Global_CurrentMap = null
var Global_CurrentEnviroment = null

#Player Items
var Global_Items = []

#Player Animations
var Global_PlayerAnimation = "Idle_Down"


#Player Miscs:
var Global_PlayerName = "Player Name"
