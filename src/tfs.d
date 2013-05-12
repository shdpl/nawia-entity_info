module tfs;

private {
	import std.conv : to,toStringz;
	import std.file : readText,read;
	import std.exception : enforce;
	import std.xml : check,DocumentParser,ElementParser;
	import std.range : iota;
	import std.algorithm : filter,array;
	import std.string : toLower,capitalize;
	import std.typecons : Nullable;

//	import otbm.otb;
}
public {
	import commonpublic;
	import commonprivate;
}

extern(C)
{
	struct TfsItemsXmlParser
	{
		cstring content;
		void function(ItemId item, cstring name) onItemHasName = null;
		void function(ItemId item, cstring suffix) onItemHasSuffix = null;
		void function(ItemId item, ItemAid action) onItemHasAid = null;
		void function(ItemId item, ItemUid unique) onItemHasUid = null;
		void function(ItemId item, cstring text) onItemHasText = null;
		void function(ItemId item, cstring subtype) onItemHasSubtype = null;
		void function(ItemId item, cstring article) onItemHasArticle = null;
		void function(ItemId item, cstring plural) onItemHasPlural = null;
		void function(ItemId item, commonpublic.ItemType type) onItemHasType = null;
		void function(ItemId item, ItemClientId item) onItemHasClientId = null;
		void function(ItemId item, bool cacheable) onItemIsCacheable = null;
		void function(ItemId item, ItemWareId id) onItemHasWareId = null;
		void function(ItemId item, float price) onItemHasPrice = null;
		void function(ItemId item, bool force) onItemHasForcedSerialization = null;
		void function(ItemId item, bool leveldoor) onItemIsLevelDoor = null;
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

//		void function(ItemId item, CorpseType type) onItemHasCorpseType = null;
	}

	struct TfsItemsOtbParser
	{
		cstring content;
		void function(ItemId item, cstring name) onItemHasName = null;
		void function(ItemId item, cstring group) onItemInGroup = null;
		void function(ItemId item, EdgeAlignment alignment) onItemIsEdge = null;
	}

	struct TfsParser
	{
		cstring data_path;
		cstring items_xml_path;
		cstring items_otb_path;
	}

	void tfsParse(ref TfsParser args)
	{
		auto dir = to!string(args.data_path);
		enforce(args.data_path);
		if( args.items_xml_path !is null )
		{
			auto file = dir~to!string(args.items_xml_path);
			auto text = readText(file).toStringz;
			auto args2= TfsItemsXmlParser(text);
			tfsParseItemsXml(args2);
		}
		/*
		if( args.items_otb_path !is null )
		{
			auto file = dir~to!string(args.items_otb_path);
			auto text = readText(file).toStringz;
			auto args2= TfsItemsOtbParser(text);
			tfsParseItemsOtb(args2);
		}*/
	}
}

void tfsParseItemsXml(ref TfsItemsXmlParser args)
{
		//item id="1492" name="" editorsuffix=" (Non PvP)"
			//attribute key="type" value="magicfield"
		auto str = to!string(args.content);
		check(str);
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
						callbackIds(args.onItemIsCacheable, ids, to!bool(value));
					break;
					case "wareid":
						callbackIds(args.onItemHasWareId, ids, to!ItemWareId(value));
					break;
					case "worth":
						callbackIds(args.onItemHasPrice, ids, to!float(value));
					break;
					case "forceserialize":
					case "forcesave":
					case "forceserialization":
						callbackIds(args.onItemHasForcedSerialization, ids, to!bool(value));
					break;
					case "leveldoor":
						callbackIds(args.onItemIsLevelDoor, ids, to!bool(value));
					break;
					case "specialdoor":
						callbackIds(args.onItemIsSpecialDoor, ids, to!bool(value));
					break;
					case "weapontype":
						callbackIds(args.onItemHasWeaponType, ids, to!WeaponType(value.capitalize));
					break;
					case "slottype":
//						callbackIds(args.onItemHasSlotType, ids, to!ItemSlot(value.filter!q{a!='-'}.array.capitalize));
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
						callbackIds(args.onItemHasStopDuration, ids, to!bool(value));
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
						callbackIds(args.onItemShowDuration, ids, to!bool(value));
					break;
					case "charges":
						callbackIds(args.onItemHasCharges, ids, to!uint(value));
					break;
					case "showattributes":
						callbackIds(args.onItemShowAttributes, ids, to!bool(value));
					break;
					default:
						enforce(false);
				}
			};
			xml.parse();
		};
		xml.parse();
}

	/*
void tfsParseItemsOtb(ref TfsItemsOtbParser args)
{
	ParserOTB parser;
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

		if( item.flags.Horizontal )
		{
			callback(args.onItemIsEdge, id, EdgeAlignment.Horizontal);
		}
		else if( item.flags.Vertical )
		{
			callback(args.onItemIsEdge, id, EdgeAlignment.Vertical);
		}
		/*

		if( item.flags.BlockSolid )
		{
			db.addRelation(id, "flag", "BlockSolid");
		}
		if( item.flags.BlockProjectile )
		{
			db.addRelation(id, "flag", "BlockProjectile");
		}
		if( item.flags.BlockPathFind )
		{
			db.addRelation(id, "flag", "BlockPathFind");
		}
		if( item.flags.HasHeight )
		{
			db.addRelation(id, "flag", "HasHeight");
		}
		if( item.flags.Usable )
		{
			db.addRelation(id, "flag", "Usable");
		}
		if( item.flags.Pickupable )
		{
			db.addRelation(id, "flag", "Pickupable");
		}
		if( item.flags.Movable )
		{
			db.addRelation(id, "flag", "Movable");
		}
		if( item.flags.Stackable )
		{
			db.addRelation(id, "flag", "Stackable");
		}
		if( item.flags.FloorChangeDown )
		{
			db.addRelation(id, "flag", "FloorChangeDown");
		}
		if( item.flags.FloorChangeNorth )
		{
			db.addRelation(id, "flag", "FloorChangeNorth");
		}
		if( item.flags.FloorChangeEast )
		{
			db.addRelation(id, "flag", "FloorChangeEast");
		}
		if( item.flags.FloorChangeSouth )
		{
			db.addRelation(id, "flag", "FloorChangeSouth");
		}
		if( item.flags.FloorChangeWest )
		{
			db.addRelation(id, "flag", "FloorChangeWest");
		}
		if( item.flags.AlwaysOnTop )
		{
			db.addRelation(id, "flag", "AlwaysOnTop");
		}
		if( item.flags.Readable )
		{
			db.addRelation(id, "flag", "Readable");
		}
		if( item.flags.Rotable )
		{
			db.addRelation(id, "flag", "Rotable");
		}
		if( item.flags.Hangable )
		{
			db.addRelation(id, "flag", "Hangable");
		}
		if( item.flags.CannotDecay )
		{
			db.addRelation(id, "flag", "CannotDecay");
		}
		if( item.flags.AllowDistRead )
		{
			db.addRelation(id, "flag", "AllowDistRead");
		}
		if( item.flags.Unused )
		{
			db.addRelation(id, "flag", "Unused");
		}
		if( item.flags.ClientCharges )
		{
			db.addRelation(id, "flag", "ClientCharges");
		}
		if( item.flags.LookThrough )
		{
			db.addRelation(id, "flag", "LookThrough");
		}
		if( item.flags.Animation )
		{
			db.addRelation(id, "flag", "Animation");
		}
		if( item.flags.WalkStack )
		{
			db.addRelation(id, "flag", "WalkStack");
		}
	};
	parser.parse(args.content);
}
	*/
