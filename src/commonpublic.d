module commonpublic;

alias uint ItemId;
alias ushort ItemAid;
alias ushort ItemUid;
alias uint ItemClientId;
alias uint ItemWareId;
alias float Percent;
alias float UPercent;

enum ItemType
{
	Unknown = 0,
	Container,
	Key,
	Magicfield,
	Depot,
	Mailbox,
	Trashholder,
	Teleport,
	Door,
	Bed,
	Rune,
}
enum WeaponType
{
	Unknown = 0,
	Sword,
	Club,
	Axe,
	Shield,
	Distance,
	Wand,
	Rod,
	Ammunition,
	Fist,
}
enum ItemSlot
{
	Unknown = 0,
	Head,
	Body,
	Legs,
	Feet,
	Backpack,
	Twohanded,
	Righthand,
	Lefthand,
	Necklace,
	Ring,
	Ammunition,
	Hand,
}
enum AmmunitionType
{
	Unknown = 0,
	Spear,
	Arrow,
	Poisonarrow,
	Burstarrow,
	Bolt,
	Powerbolt,
	Smallstone,
	Largerrock,
	Throwingstar,
	Throwingknife,
	Snowball,
	Huntingspear,
	Royalspear,
	Enchantedspear,
	Sniperarrow,
	Onyxarrow,
	Piercingbolt,
	Infernalbolt,
	Flasharrow,
	Flamingarrow,
	Shiverarrow,
	Eartharrow,
	Etheralspear,
}

enum ShootType
{
	Unknown = 0,
	Spear,
	Bolt,
	Arrow,
	Fire,
	Energy,
	Poisonarrow,
	Burstarrow,
	Throwingstar,
	Throwingknife,
	Smallstone,
	Death,
	Largerock,
	Snowball,
	Powerbolt,
	Poison,
	Infernalbolt,
	Huntingspear,
	Enchantedspear,
	Redstar,
	Greenstar,
	Royalspear,
	Sniperarrow,
	Onyxarrow,
	Piercingbolt,
	Whirlwindsword,
	Whirlwindaxe,
	Whirlwindclub,
	Etherealspear,
	Ice,
	Earth,
	Holy,
	Suddendeath,
	Flasharrow,
	Flamingarrow,
	Shiverarrow,
	Energyball,
	Smallice,
	Smallholy,
	Smallearth,
	Eartharrow,
	Explosion,
	Cake,
	Tarsalarrow,
	Vortexbolt,
	Prismaticbolt,
	Crystallinearrow,
	Drillbolt,
	Envenomedarrow,
}

enum MagicEffect
{
	Redspark,
	Bluebubble,
	Poff,
	Yellowspark,
	Explosionarea,
	Explosion,
	Firearea,
	Yellowbubble,
	Greenbubble,
	Blackspark,
	Teleport,
	Energy,
	Blueshimmer,
	Redshimmer,
	Greenshimmer,
	Fire,
	Greenspark,
	Mortarea,
	Greennote,
	Rednote,
	Poison,
	Yellownote,
	Purplenote,
	Bluenote,
	Whitenote,
	Bubbles,
	Dice,
	Giftwraps,
	Yellowfirework,
	Redfirework,
	Bluefirework,
	Stun,
	Sleep,
	Watercreature,
	Groundshaker,
	Hearts,
	Fireattack,
	Energyarea,
	Smallclouds,
	Holydamage,
	Bigclouds,
	Icearea,
	Icetornado,
	Iceattack,
	Stones,
	Smallplants,
	Carniphila,
	Purpleenergy,
	Yellowenergy,
	Holyarea,
	Bigplants,
	Cake,
	Giantice,
	Watersplash,
	Plantattack,
	Tutorialarrow,
	TutorialSquare,
	Mirrorhorizontal,
	Skullhorizontal,
	Skullvertical,
	Assassin,
	Stepshorizontal,
	Bloodysteps,
	Stepsvertical,
	Yalaharighost,
	Bats,
	Smoke,
	Insects,
	Dragonhead,
	Orcshaman,
	Orcshamanfire,
	Thunder,
	Ferumbras,
	Confettihorizontal,
	Confettivertical,
}


enum EdgeAlignment
{
	Horizontal,
	Vertical
}

enum AmmoAction
{
	Unknown = 0,
	Removecount,
	Removecharge,
	Move,
	Moveback,
};

enum CombatCondition
{ // subset of combatTypeNames (not the same of)
	Physical,
	Energy,
	Earth,
	Fire,
	Drown,
	Ice,
	Holy,
	Death,
}

enum Direction
{
	Undefined = 0,
	North,
	East,
	South,
	West,
	Southwest,
	Southeast,
	Northwest,
	Northeast,
}

enum FloorChange
{
	Undefined = 0,
	Down,
	North,
	South,
	West,
	East,
	Northex,
	Southex,
	Westex,
	Eastex,
}

enum CorpseType
{
	Undefined = 0,
	Venom,
	Blood,
	Undead,
	Fire,
	Energy,
}

enum FluidType
{
	None = 0,
	Water,
	Blood,
	Beer,
	Slime,
	Lemonade,
	Milk,
	Mana,
	Life,
	Oil,
	Urine,
	Coconutmilk,
	Wine,
	Mud,
	Fruitjuice,
	Lava,
	Rum,
	Swamp,
	Tea,
	Mead,
}
