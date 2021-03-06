/**
 * Authors: Nawia Team <development@nawia.net>
 * License: GNU Lesser General Public License
 * Todo: Replace semi-c API with D API + C-bindings
 */
module tfs;

private {
	import std.conv : to,toStringz;
	import std.file : read;
	import std.exception : enforce;
	import std.xml : check,DocumentParser,ElementParser;
	import std.range : iota;
	import std.algorithm : filter,array;
	import std.string : toLower,capitalize;
	import std.typecons : Nullable;
	import std.path : buildPath;

	import otbm.otb;
}
public {
	import commonpublic;
	import commonprivate;
}

extern(C)
{
	struct TfsItemsXmlParser
	{
		mixin FunctionsCommon;
		void function(ItemId item, cstring suffix) onItemHasSuffix = null;
		void function(ItemId item, ItemAid action) onItemHasAid = null;
		void function(ItemId item, ItemUid unique) onItemHasUid = null;
		void function(ItemId item, cstring text) onItemHasText = null;
		void function(ItemId item, cstring subtype) onItemHasSubtype = null;
		void function(ItemId item, cstring article) onItemHasArticle = null;
		void function(ItemId item, cstring plural) onItemHasPlural = null;
		void function(ItemId item, commonpublic.ItemType type) onItemHasType = null; //?
		void function(ItemId item, bool cacheable) onItemIsCacheable = null;
		void function(ItemId item, cstring description) onItemHasLightDescription = null;
		void function(ItemId item, cstring name) onItemHasRuneSpellName = null;
		/// oz = weight/100
		void function(ItemId item, uint weight) onItemHasWeight = null;
		void function(ItemId item, bool show) onItemHasShowCount = null;
		void function(ItemId item, int armor) onItemHasArmor = null;
		void function(ItemId item, int defense) onItemHasDefense = null;
		void function(ItemId item, int extradef) onItemHasExtraDefense = null;
		void function(ItemId item, int attack) onItemHasAttack = null;
		void function(ItemId item, int extraatk) onItemHasExtraAttack = null;
		void function(ItemId item, int speed) onItemHasAttackSpeed = null;
		void function(ItemId item, int rotate) onItemHasRotateTo = null;
		void function(ItemId item, bool allow) onItemIsAllowedToPickUp = null;
		void function(ItemId item, CorpseType type) onItemHasCorpseType = null;
		void function(ItemId item, uint size) onItemHasContainerSize = null;
		void function(ItemId item, FluidType type) onItemIsFluidSource = null;
		void function(ItemId item, bool writeable) onItemIsWriteable = null;
		void function(ItemId item, uint length) onItemHasMaxTextLength = null;
		void function(ItemId item, cstring author) onItemHasAuthor = null;
		void function(ItemId item, uint date) onItemHasLastEditDate = null;
		void function(ItemId item, ItemId id) onItemHasWriteOnceId = null;
		void function(ItemId item, ItemWareId id) onItemHasWareId = null;
		void function(ItemId item, float price) onItemHasPrice = null;
		void function(ItemId item, bool force) onItemHasForcedSerialization = null;
		void function(ItemId item, uint leveldoor) onItemIsLevelDoor = null;
		void function(ItemId item, bool specialdoor) onItemIsSpecialDoor = null;
		void function(ItemId item, WeaponType type) onItemHasWeaponType = null;
		void function(ItemId item, ItemSlot type) onItemHasSlotType = null;
		void function(ItemId item, AmmunitionType type) onItemHasAmmunitionType = null;
		void function(ItemId item, ShootType type) onItemHasShootType = null;
		void function(ItemId item, MagicEffect effect) onItemHasMagicEffect = null;
		void function(ItemId item, uint shootRange) onItemHasShootRange = null;
		void function(ItemId item, bool has) onItemHasStopDuration = null;
		void function(ItemId item, ItemId to) onItemHasDecayTo = null;
		void function(ItemId item, ItemId to) onItemHasTransformOnEquipTo = null;
		void function(ItemId item, ItemId to) onItemHasTransformOnDeequipTo = null;
		void function(ItemId item, uint duration) onItemHasDuration = null;
		void function(ItemId item, bool show) onItemShowDuration = null;
		void function(ItemId item, uint charges) onItemHasCharges = null;
		void function(ItemId item, bool show) onItemShowAttributes = null;
		void function(ItemId item, UPercent value) onItemHasBreakChance = null;
		void function(ItemId item, AmmoAction action) onItemHasAmmoAction = null;
		void function(ItemId item, Percent value) onItemHasHitChance = null;
		void function(ItemId item, UPercent value) onItemHasMaxHitChance = null;
		void function(ItemId item, bool dualwield) onItemIsDualwield = null;
		void function(ItemId item, bool preventloss) onItemHasPreventLoss = null;
		void function(ItemId item, bool preventdrop) onItemHasPreventDrop = null;
		void function(ItemId item, bool invisible) onItemHasInvisible = null;
		void function(ItemId id, int modifier) onItemHasSpeedModifier = null;

		void function(ItemId id, int gain) onItemHasHealthGain = null;
		void function(ItemId id, uint ticks) onItemHasHealthTicks = null;

		void function(ItemId id, int gain) onItemHasManaGain = null;
		void function(ItemId id, int ticks) onItemHasManaTicks = null;

		void function(ItemId id, bool has) onItemActivatesManaShield = null;

		void function(ItemId id, int level) onItemRequiresSword = null;
		void function(ItemId id, int level) onItemRequiresAxe = null;
		void function(ItemId id, int level) onItemRequiresClub = null;
		void function(ItemId id, int level) onItemRequiresDistance = null;
		void function(ItemId id, int level) onItemRequiresFishing = null;
		void function(ItemId id, int level) onItemRequiresShielding = null;
		void function(ItemId id, int level) onItemRequiresFist = null;

		void function(ItemId id, int points) onItemModifiesMagicGainPoints = null;
		void function(ItemId id, Percent modifier) onItemModifiesMagicGainPercent = null;

		void function(ItemId id, int points) onItemModifiesMagicStrengthPoints = null;
		void function(ItemId id, Percent modifier) onItemModifiesMagicStrengthPercent = null;

		void function(ItemId id, int points) onItemModifiesMaxHealthPoints = null;
		void function(ItemId id, Percent modifier) onItemModifiesMaxHealthPercent = null;

		void function(ItemId id, int points) onItemModifiesMaxManaPoints = null;
		void function(ItemId id, Percent modifier) onItemModifiesMaxManaPercent = null;

		void function(ItemId id, int points) onItemModifiesMaxSoulPoints = null;
		void function(ItemId id, Percent modifier) onItemModifiesMaxSoulPercent = null;

		void function(ItemId id, int points) onItemModifiesHealingStrengthPoints = null;
		void function(ItemId id, Percent modifier) onItemModifiesHealingStrengthPercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbFieldEnergyPercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbFieldFirePercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbFieldEarthPercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbAllPercent = null;

		/// energy + fire + earth + ice
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbElementPercent = null;
		/// energy + fire + earth + ice + holy + death
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbMagicPercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbEnergyPercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbFirePercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbEarthPercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbIcePercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbHolyPercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbDeathPercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbDrainLifePercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbDrainManaPercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbDrownPercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbPhysicalPercent = null;

		void function(ItemId id, Percent modifier) onItemModifiesAbsorbHealingPercent = null;
		void function(ItemId id, Percent modifier) onItemModifiesAbsorbUndefinedPercent = null;

		//TODO: reflect
		//
		//TODO: suppress

		void function(ItemId id, Percent modifier) onItemAppliesCombatCondition = null;

		//TODO: element (which deals elemental damage)

		void function(ItemId id, bool replaceable) onItemIsReplaceable = null;
		void function(ItemId id, Direction which) onItemHasPartnerDirection = null;

		void function(ItemId id, ItemId to) onItemHasTransformFemaleOnUse = null;
		void function(ItemId id, ItemId to) onItemHasTransformMaleOnUse = null;
		void function(ItemId id, ItemId to) onItemHasTransformOnUse = null;

		void function(ItemId id, bool has) onItemHasWalkstackPosition = null;

//		void function(ItemId item, CorpseType type) onItemHasCorpseType = null;
	}

	private mixin template FunctionsCommon()
	{
		void function(ItemId item, cstring name) onItemHasName = null;
		void function(ItemId item, bool vertical) onItemIsVertical = null;
		void function(ItemId item, bool horizontal) onItemIsHorizontal = null;
		void function(ItemId item, bool pickupable) onItemIsPickupable = null;
		void function(ItemId item, bool blocks) onItemBlocksSolid = null;
		void function(ItemId item, bool blocks) onItemBlocksProjectile = null;
		void function(ItemId item, bool blocks) onItemBlocksPathFind = null;
		void function(ItemId item, ushort strength) onItemHasLightLevel = null;
		void function(ItemId item, ushort color) onItemHasLightColor = null;
		void function(ItemId item, bool movable) onItemIsMovable = null;
		void function(ItemId item, FloorChange change) onItemHasFloorChange = null;
		void function(ItemId item, bool readable) onItemIsReadable = null;
		void function(ItemId item, ItemClientId item) onItemHasClientId = null;
	}

	struct TfsItemsOtbParser
	{
		mixin FunctionsCommon;
		void function(ItemId item, cstring group) onItemInGroup = null;
		void function(ItemId item, bool has) onItemHasHeight = null;
		void function(ItemId item, bool usable) onItemIsUsable = null;
		void function(ItemId item, bool stackable) onItemIsStackable = null;
		void function(ItemId item, bool always) onItemIsAlwaysOnTop = null;
		void function(ItemId item, bool rotable) onItemIsRotable = null;
		void function(ItemId item, bool hangable) onItemIsHangable = null;
		void function(ItemId item, bool nodecay) onItemCannotDecay = null;
		void function(ItemId item, bool readable) onItemCanBeReadFromDistance = null;
		void function(ItemId item, bool chargable) onItemCanHaveCharges = null;
		void function(ItemId item, bool translucent) onItemHasLookThrough = null;
		void function(ItemId item, bool animatable) onItemHasAnimation = null;
		void function(ItemId item, bool walkstack) onItemCanHaveWalkstack = null;
		void function(ItemId item, ubyte index) onItemHasTopOrder = null;
		void function(ItemId item, ubyte[16] hash) onItemHasHash = null;
		void function(ItemId item, ushort color) onItemHasMiniMapColor = null;
	}

	struct TfsParser
	{
		TfsItemsXmlParser items_xml;
		TfsItemsOtbParser items_otb;
	}

	void tfsParse(cstring data_path, ref TfsParser args)
	{
		enforce(data_path, "No valid TFS data path given");
		auto dir = to!string(data_path);

		{
			auto file = buildPath(dir,"items","items.xml");
			auto content = read(file);
			tfsParseItemsXml(content.ptr,to!uint(content.length),args.items_xml);
		}
		{
			auto file = buildPath(dir,"items","items.otb");
			auto content = read(file);
			tfsParseItemsOtb(content.ptr,to!uint(content.length),args.items_otb);
		}
	}
}

void tfsParseItemsXml(void* data, uint data_n,ref TfsItemsXmlParser args)
{
		//item id="1492" name="" editorsuffix=" (Non PvP)"
		// attribute key="type" value="magicfield"
		auto str = to!string(cast(char[])data[0..data_n]);
		//check(str);
		auto xml = new DocumentParser(str);
		xml.onStartTag["item"] = (ElementParser xml)
		{
			ItemId[] ids;
			if( "id" in xml.tag.attr )
			{
				ids ~= to!ItemId(xml.tag.attr["id"]);
			}
			else
			{
				auto id_start = to!ItemId(xml.tag.attr["fromid"]);
				auto id_end = to!ItemId(xml.tag.attr["toid"]);
				for( ItemId id=id_start; id <= id_end; id++ )
				{
					ids ~= id;
				}
			}

			if( "name" in xml.tag.attr )
			{
				auto name = xml.tag.attr["name"];
				callbackIds(args.onItemHasName, ids,name.toStringz);
			}

			if( "editorsuffix" in xml.tag.attr )
			{
				auto suffix = xml.tag.attr["editorsuffix"];
				callbackIds(args.onItemHasSuffix, ids,suffix.toStringz);
			}

			if( "article" in xml.tag.attr )
			{
				auto article = xml.tag.attr["article"];
				callbackIds(args.onItemHasArticle, ids,article.toStringz);
			}

			if( "plural" in xml.tag.attr )
			{
				auto plural = xml.tag.attr["plural"];
				callbackIds(args.onItemHasPlural, ids,plural.toStringz);
			}


			string subtype;
			if( "subtype" in xml.tag.attr )
			{
				subtype = xml.tag.attr["subtype"];
			}
			else if( "subType" in xml.tag.attr )
			{
				subtype = xml.tag.attr["subType"];
			}
			if( subtype != string.init )
			{
				callbackIds(args.onItemHasSubtype, ids,subtype.toStringz);
			}

			Nullable!ItemAid aid;
			if( "actionid" in xml.tag.attr )
			{
				aid = to!ItemAid(xml.tag.attr["actionid"]);
			}
			else if ( "actionId" in xml.tag.attr )
			{
				aid = to!ItemAid(xml.tag.attr["actionId"]);
			}
			if( !aid.isNull )
			{
				callbackIds(args.onItemHasAid, ids,aid);
			}

			Nullable!ItemUid uid;
			if( "uniqueid" in xml.tag.attr )
			{
				uid = to!ItemUid(xml.tag.attr["uniqueid"]);
			}
			else if ( "uniqueId" in xml.tag.attr )
			{
				uid = to!ItemAid(xml.tag.attr["uniqueId"]);
			}
			if( !uid.isNull )
			{
				callbackIds(args.onItemHasUid, ids,aid);
			}

			Nullable!cstring text;
			if( "text" in xml.tag.attr )
			{
				text = xml.tag.attr["text"].toStringz;
			}
			if( !text.isNull )
			{
				callbackIds(args.onItemHasText, ids,text);
			}

			// TODO: if item is container

			xml.onStartTag["attribute"] = (ElementParser xml)
			{
				auto key = xml.tag.attr["key"];
				auto value = xml.tag.attr["value"];
				switch( key.toLower )
				{
					case "aid":
						callbackIds(args.onItemHasAid, ids,to!ItemAid(value));
					break;
					case "uid":
						callbackIds(args.onItemHasUid, ids,to!ItemUid(value));
					break;
					case "type":
						callbackIds(args.onItemHasType, ids,to!(commonpublic.ItemType)(value.capitalize));
					break;
					case "name":
						callbackIds(args.onItemHasName, ids,value.toStringz);
					break;
					case "article":
						callbackIds(args.onItemHasArticle, ids,value.toStringz);
					break;
					case "plural":
						callbackIds(args.onItemHasPlural, ids,value.toStringz);
					break;
					case "clientid":
						callbackIds(args.onItemHasClientId, ids,to!ItemClientId(value));
					break;
					case "cache":
						callbackIds(args.onItemIsCacheable, ids, tfsBool(value));
					break;
					case "wareid":
						callbackIds(args.onItemHasWareId, ids, to!ItemWareId(value));
					break;
					case "blocksolid":
						callbackIds(args.onItemBlocksSolid, ids, tfsBool(value));
					break;
					case "blockprojectile":
						callbackIds(args.onItemBlocksProjectile, ids, tfsBool(value));
					break;
					case "blockpathfind":
						callbackIds(args.onItemBlocksPathFind, ids, tfsBool(value));
					break;
					case "lightlevel":
						callbackIds(args.onItemHasLightLevel, ids, to!ushort(value));
					break;
					case "lightcolor":
						callbackIds(args.onItemHasLightColor, ids, to!ushort(value));
					break;
					case "description":
						callbackIds(args.onItemHasLightDescription, ids, value.toStringz);
					break;
					case "runespellname":
						callbackIds(args.onItemHasRuneSpellName, ids, value.toStringz);
					break;
					case "weight":
						callbackIds(args.onItemHasWeight, ids, to!uint(value)); // oz=weight/100
					break;
					case "showcount":
						callbackIds(args.onItemHasShowCount, ids, tfsBool(value));
					break;
					case "armor":
						callbackIds(args.onItemHasArmor, ids, to!int(value));
					break;
					case "defense":
						callbackIds(args.onItemHasDefense, ids, to!int(value));
					break;
					case "extradefense":
						callbackIds(args.onItemHasExtraDefense, ids, to!int(value));
					break;
					case "attack":
						callbackIds(args.onItemHasAttack, ids, to!int(value));
					break;
					case "extraattack":
						callbackIds(args.onItemHasExtraAttack, ids, to!int(value));
					break;
					case "attackspeed":
						callbackIds(args.onItemHasAttackSpeed, ids, to!int(value));
					break;
					case "rotateto":
						callbackIds(args.onItemHasRotateTo, ids, to!int(value));
					break;
					case "movable":
						callbackIds(args.onItemIsMovable, ids, tfsBool(value));
					break;
					case "vertical":
						callbackIds(args.onItemIsVertical, ids, tfsBool(value));
					break;
					case "horizontal":
						callbackIds(args.onItemIsHorizontal, ids, tfsBool(value));
					break;
					case "pickupable":
						callbackIds(args.onItemIsPickupable, ids, tfsBool(value));
					break;
					case "allowpickupable":
						callbackIds(args.onItemIsAllowedToPickUp, ids, tfsBool(value));
					break;
					case "floorchange":
						callbackIds(args.onItemHasFloorChange, ids, to!FloorChange(value.capitalize));
					break;
					case "corpsetype":
						callbackIds(args.onItemHasCorpseType, ids, to!CorpseType(value.capitalize));
					break;
					case "containersize":
						callbackIds(args.onItemHasContainerSize, ids, to!uint(value));
					break;
					case "fluidsource":
						callbackIds(args.onItemIsFluidSource, ids, to!FluidType(value.capitalize));
					break;
					case "writeable":
						callbackIds(args.onItemIsWriteable, ids, tfsBool(value));
					break;
					case "readable":
						callbackIds(args.onItemIsReadable, ids, tfsBool(value));
					break;
					case "maxtextlength":
						callbackIds(args.onItemHasMaxTextLength, ids, to!uint(value));
					break;
					case "text":
						callbackIds(args.onItemHasText, ids, value.toStringz);
					break;
					case "author":
						callbackIds(args.onItemHasAuthor, ids, value.toStringz);
					break;
					case "date":
						callbackIds(args.onItemHasLastEditDate, ids, to!uint(value));
					break;
					case "writeonceitemid":
						callbackIds(args.onItemHasWriteOnceId, ids, to!ItemId(value));
					break;
					case "worth":
						callbackIds(args.onItemHasPrice, ids, to!float(value));
					break;
					case "forceserialize":
					case "forcesave":
					case "forceserialization":
						callbackIds(args.onItemHasForcedSerialization, ids, tfsBool(value));
					break;
					case "leveldoor":
						callbackIds(args.onItemIsLevelDoor, ids, to!uint(value));
					break;
					case "specialdoor":
						callbackIds(args.onItemIsSpecialDoor, ids, tfsBool(value));
					break;
					case "weapontype":
						callbackIds(args.onItemHasWeaponType, ids, to!WeaponType(value.capitalize));
					break;
					case "slottype":
						callbackIds(args.onItemHasSlotType, ids, to!ItemSlot(value.filter!q{a!='-'}.array.capitalize));
					break;
					case "ammotype":
						callbackIds(args.onItemHasAmmunitionType, ids, to!AmmunitionType(value.capitalize));
					break;
					case "shoottype":
						callbackIds(args.onItemHasShootType, ids, to!ShootType(value.capitalize));
					break;
					case "effect":
						callbackIds(args.onItemHasMagicEffect, ids, to!MagicEffect(value.capitalize));
					break;
					case "range":
						callbackIds(args.onItemHasShootRange, ids, to!uint(value));
					break;
					case "stopduration":
						callbackIds(args.onItemHasStopDuration, ids, tfsBool(value));
					break;
					case "decayto":
						callbackIds(args.onItemHasDecayTo, ids, to!ItemId(value));
					break;
					case "transformequipto":
						callbackIds(args.onItemHasTransformOnEquipTo, ids, to!ItemId(value));
					break;
					case "transformdeequipto":
						callbackIds(args.onItemHasTransformOnDeequipTo, ids, to!ItemId(value));
					break;
					case "duration":
						callbackIds(args.onItemHasDuration, ids, to!uint(value));
					break;
					case "showduration":
						callbackIds(args.onItemShowDuration, ids, tfsBool(value));
					break;
					case "charges":
						callbackIds(args.onItemHasCharges, ids, to!uint(value));
					break;
					case "showattributes":
						callbackIds(args.onItemShowAttributes, ids, tfsBool(value));
					break;
					case "breakchance":
						callbackIds(args.onItemHasBreakChance, ids, to!Percent(value));
					break;
					case "ammoaction":
						callbackIds(args.onItemHasAmmoAction, ids, to!AmmoAction(value.filter!q{(a!='-')&&(a!=' ')}.array.capitalize));
					break;
					case "hitchance":
						callbackIds(args.onItemHasHitChance, ids, to!Percent(value));
					break;
					case "maxhitchance":
						callbackIds(args.onItemHasMaxHitChance, ids, to!Percent(value));
					break;
					case "dualwield":
						callbackIds(args.onItemIsDualwield, ids, tfsBool(value));
					break;
					case "preventloss":
						callbackIds(args.onItemHasPreventLoss, ids, tfsBool(value));
					break;
					case "preventdrop":
						callbackIds(args.onItemHasPreventDrop, ids, tfsBool(value));
					break;
					case "invisible":
						callbackIds(args.onItemHasInvisible, ids, tfsBool(value));
					break;
					case "speed":
						callbackIds(args.onItemHasSpeedModifier, ids, to!int(value));
					break;
					case "healthgain":
						callbackIds(args.onItemHasHealthGain, ids, to!int(value));
					break;
					case "healthticks":
						callbackIds(args.onItemHasHealthTicks, ids, to!uint(value));
					break;
					case "managain":
						callbackIds(args.onItemHasManaGain, ids, to!int(value));
					break;
					case "manaticks":
						callbackIds(args.onItemHasManaTicks, ids, to!uint(value));
					break;
					case "manashield":
						callbackIds(args.onItemActivatesManaShield, ids, tfsBool(value));
					break;
					case "skillsword":
						callbackIds(args.onItemRequiresSword, ids, to!int(value));
					break;
					case "skillaxe":
						callbackIds(args.onItemRequiresAxe, ids, to!int(value));
					break;
					case "skillclub":
						callbackIds(args.onItemRequiresClub, ids, to!int(value));
					break;
					case "skilldist":
						callbackIds(args.onItemRequiresDistance, ids, to!int(value));
					break;
					case "skillfish":
						callbackIds(args.onItemRequiresFishing, ids, to!int(value));
					break;
					case "skillshield":
						callbackIds(args.onItemRequiresShielding, ids, to!int(value));
					break;
					case "skillfist":
						callbackIds(args.onItemRequiresFist, ids, to!int(value));
					break;
					case "maxhealthpoints":
						callbackIds(args.onItemModifiesMaxHealthPoints, ids, to!int(value));
					break;
					case "maxhealthpercent":
						callbackIds(args.onItemModifiesMaxHealthPercent, ids, to!Percent(value));
					break;
					case "maxmanapoints":
						callbackIds(args.onItemModifiesMaxManaPoints, ids, to!int(value));
					break;
					case "maxmanapercent":
						callbackIds(args.onItemModifiesMaxManaPercent, ids, to!Percent(value));
					break;
					case "soulpoints":
						callbackIds(args.onItemModifiesMaxSoulPoints, ids, to!int(value));
					break;
					case "soulpercent":
						callbackIds(args.onItemModifiesMaxSoulPercent, ids, to!Percent(value));
					break;
					case "magiclevelpoints":
						callbackIds(args.onItemModifiesMagicGainPoints, ids, to!int(value));
					break;
					case "magiclevelpercent":
						callbackIds(args.onItemModifiesMagicGainPercent, ids, to!Percent(value));
					break;
					case "magicvalue":
						callbackIds(args.onItemModifiesMagicStrengthPoints, ids, to!int(value));
					break;
					case "magicpercent":
						callbackIds(args.onItemModifiesMagicStrengthPercent, ids, to!Percent(value));
					break;
					case "increasehealingvalue":
						callbackIds(args.onItemModifiesHealingStrengthPoints, ids, to!int(value));
					break;
					case "increasehealingpercent":
						callbackIds(args.onItemModifiesHealingStrengthPercent, ids, to!Percent(value));
					break;
					case "fieldabsorbpercentenergy":
						callbackIds(args.onItemModifiesAbsorbFieldEnergyPercent, ids, to!Percent(value));
					break;
					case "fieldabsorbpercentfire":
						callbackIds(args.onItemModifiesAbsorbFieldFirePercent, ids, to!Percent(value));
					break;
					case "fieldabsorbpercentearth":
						callbackIds(args.onItemModifiesAbsorbFieldEarthPercent, ids, to!Percent(value));
					break;
					case "absorbpercentall":
						callbackIds(args.onItemModifiesAbsorbAllPercent, ids, to!Percent(value));
					break;
					case "absorbpercentelements":
						callbackIds(args.onItemModifiesAbsorbElementPercent, ids, to!Percent(value));
					break;
					case "absorbpercentmagic":
						callbackIds(args.onItemModifiesAbsorbMagicPercent, ids, to!Percent(value));
					break;
					case "absorbpercentenergy":
						callbackIds(args.onItemModifiesAbsorbEnergyPercent, ids, to!Percent(value));
					break;
					case "absorbpercentfire":
						callbackIds(args.onItemModifiesAbsorbFirePercent, ids, to!Percent(value));
					break;
					case "absorbpercentearth":
						callbackIds(args.onItemModifiesAbsorbEarthPercent, ids, to!Percent(value));
					break;
					case "absorbpercentice":
						callbackIds(args.onItemModifiesAbsorbIcePercent, ids, to!Percent(value));
					break;
					case "absorbpercentholy":
						callbackIds(args.onItemModifiesAbsorbHolyPercent, ids, to!Percent(value));
					break;
					case "absorbpercentdeath":
						callbackIds(args.onItemModifiesAbsorbDeathPercent, ids, to!Percent(value));
					break;
					case "absorbpercentlifedrain":
						callbackIds(args.onItemModifiesAbsorbDrainLifePercent, ids, to!Percent(value));
					break;
					case "absorbpercentmanadrain":
						callbackIds(args.onItemModifiesAbsorbDrainManaPercent, ids, to!Percent(value));
					break;
					case "absorbpercentdrown":
						callbackIds(args.onItemModifiesAbsorbDrownPercent, ids, to!Percent(value));
					break;
					case "absorbpercentphysical":
						callbackIds(args.onItemModifiesAbsorbPhysicalPercent, ids, to!Percent(value));
					break;
					case "absorbpercenthealing":
						callbackIds(args.onItemModifiesAbsorbHealingPercent, ids, to!Percent(value));
					break;
					case "absorbpercentundefined":
						callbackIds(args.onItemModifiesAbsorbUndefinedPercent, ids, to!Percent(value));
					break;
					case "field":
						callbackIds(args.onItemAppliesCombatCondition, ids, to!CombatCondition(value.capitalize));
						/*
						xml.onStartTag["attributes"] = (ElementParser xml)
						{
							auto key = xml.tag.attr["key"];
							auto value = xml.tag.attr["value"];
							switch( key.toLower )
							{
								case "ticks":
									//
								break;
								case "count":
									//
								break;
								case "start":
									//
								break;
								case "damage":
									//
								break;
								default:
							//		enforce(false, text("Unknown field attribute ",key));
							}
							//FIXME: buffer for passing as argument
						};
						xml.parse();
						*/
					break;
					case "replaceable":
						callbackIds(args.onItemIsReplaceable, ids, tfsBool(value));
					break;
					case "partnerdirection":
						callbackIds(args.onItemHasPartnerDirection, ids, to!Direction(value.capitalize));
					break;
					case "maletransformto":
						callbackIds(args.onItemHasTransformMaleOnUse, ids, to!ItemId(value));
					break;
					case "femaletransformto":
						callbackIds(args.onItemHasTransformFemaleOnUse, ids, to!ItemId(value));
					break;
					case "transformto":
						callbackIds(args.onItemHasTransformOnUse, ids, to!ItemId(value));
					break;
					case "walkstack":
						callbackIds(args.onItemHasWalkstackPosition, ids, tfsBool(value));
					break;
					default:
						//enforce(false,text(""));
				}
			};
			xml.parse();
		};
		xml.parse();
}

void tfsParseItemsOtb(void* data, uint data_n, ref TfsItemsOtbParser outer)
{
	static TfsItemsOtbParser* args = null;
	ParserOTB parser;
	args = &outer;
	parser.onItemType = (otbm.otb.ItemType item)
	{
		auto id = to!ItemId(to!string(item.serverId));
		if( item.name != string.init )
		{
			callback(args.onItemHasName, id,item.name.toStringz);
		}
		if( item.group != ItemGroup.NONE )
		{
			callback(args.onItemInGroup, id, to!string(item.group).toLower.toStringz);
		}
		{ //flags
			if( item.flags.Horizontal )
			{
				callback(args.onItemIsHorizontal, id, true);
			}
			else if( item.flags.Vertical )
			{
				callback(args.onItemIsVertical, id, true);
			}
			if( item.flags.BlockSolid )
			{
				callback(args.onItemBlocksSolid,id,true);
			}
			if( item.flags.BlockProjectile )
			{
				callback(args.onItemBlocksProjectile,id,true);
			}
			if( item.flags.BlockPathFind )
			{
				callback(args.onItemBlocksPathFind,id,true);
			}
			if( item.flags.HasHeight )
			{
				callback(args.onItemHasHeight,id,true);
			}
			if( item.flags.Usable )
			{
				callback(args.onItemIsUsable,id,true);
			}
			if( item.flags.Pickupable )
			{
				callback(args.onItemIsPickupable,id,true);
			}
			if( item.flags.Movable )
			{
				callback(args.onItemIsMovable,id,true);
			}
			if( item.flags.Stackable )
			{
				callback(args.onItemIsStackable,id,true);
			}
			if( item.flags.FloorChangeDown )
			{
				callback(args.onItemHasFloorChange,id,FloorChange.Down);
			}
			if( item.flags.FloorChangeNorth )
			{
				callback(args.onItemHasFloorChange,id,FloorChange.North);
			}
			if( item.flags.FloorChangeEast )
			{
				callback(args.onItemHasFloorChange,id,FloorChange.East);
			}
			if( item.flags.FloorChangeSouth )
			{
				callback(args.onItemHasFloorChange,id,FloorChange.South);
			}
			if( item.flags.FloorChangeWest )
			{
				callback(args.onItemHasFloorChange,id,FloorChange.West);
			}
			if( item.flags.AlwaysOnTop )
			{
				callback(args.onItemIsAlwaysOnTop,id,true);
			}
			if( item.flags.Readable )
			{
				callback(args.onItemIsReadable,id,true);
			}
			if( item.flags.Rotable )
			{
				callback(args.onItemIsRotable,id,true);
			}
			if( item.flags.Hangable )
			{
				callback(args.onItemIsHangable,id,true);
			}
			if( item.flags.CannotDecay )
			{
				callback(args.onItemCannotDecay,id,true);
			}
			if( item.flags.AllowDistRead )
			{
				callback(args.onItemCanBeReadFromDistance,id,true);
			}
			if( item.flags.Unused )
			{
				// maybe notify?
			}
			if( item.flags.ClientCharges )
			{
				callback(args.onItemCanHaveCharges,id,true);//!=HasCharges
			}
			if( item.flags.LookThrough )
			{
				callback(args.onItemHasLookThrough,id,true);
			}
			if( item.flags.Animation )
			{
				callback(args.onItemHasAnimation,id,true);
			}
			if( item.flags.WalkStack )
			{
				callback(args.onItemCanHaveWalkstack,id,true);
			}
		}
		if( item.clientId )
		{
			callback(args.onItemHasClientId,id,item.clientId);
		}
		if( item.light2.level )
		{
			callback(args.onItemHasLightLevel,id,item.light2.level);
			callback(args.onItemHasLightColor,id,item.light2.color);
		}
		if( item.topOrder )
		{
			callback(args.onItemHasTopOrder,id,item.topOrder);
		}
		callback(args.onItemHasHash,id,item.hash);
		if( item.miniMapColor )
		{
			callback(args.onItemHasMiniMapColor,id,item.miniMapColor);
		}
	};
	parser.parse(data[0..data_n]);
}
