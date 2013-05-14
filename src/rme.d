/**
 * Authors: Nawia Team <development@nawia.net>
 * License: GNU Lesser General Public License
 * Todo: Replace semi-c API with D API + C-bindings
 */
module rme;

private {
	import std.string : toStringz;
	import std.file;
	import std.path : buildPath;
	import std.exception : enforce;
	import std.conv : to,text;
	import std.xml;
	import std.typecons : Nullable;
	import std.traits;
	import std.typetuple;
	import std.algorithm : iota,cmp;
}
public {
	import commonpublic;
}

extern(C)
{
	alias const(char)* edge_t;
	alias const(char)* brush_t;
	alias const(char)* brush_tt;
	alias const(char)* wall_t;
	alias const(char)* name_t;
	alias const(char)* tileset_t;

	struct RmeBorderParser
	{
		const(char)* data;

		void function(ItemId,edge_t) isEdge = null;
	}
	struct RmeDoodadsParser
	{
		const(char)* data;

		void function(brush_t,brush_tt) isBrushType = null;
		void function(ItemId,brush_t) isBrush = null;
		void function(ItemId,wall_t) isWall = null;
		void function(ItemId,edge_t) isEdge = null;
		void function(ItemId,name_t) isNamed = null;
		void function(brush_t,brush_t) isFriend = null;
		void function(brush_t,brush_t) isBorder = null;
	}
	struct RmeGroundsParser
	{
		const(char)* data;

		void function(brush_t,brush_tt) isBrushType = null;
		void function(ItemId,brush_t) isBrush = null;
		void function(ItemId,wall_t) isWall = null;
		void function(ItemId,edge_t) isEdge = null;
		void function(ItemId,name_t) isNamed = null;
		void function(brush_t,brush_t) isFriend = null;
		void function(brush_t,brush_t) isBorder = null;
	}
	struct RmeWallsParser
	{
		const(char)* data;

		void function(brush_t,brush_tt) isBrushType = null;
		void function(ItemId,brush_t) isBrush = null;
		void function(ItemId,wall_t) isWall = null;
		void function(ItemId,edge_t) isEdge = null;
		void function(ItemId,name_t) isNamed = null;
		void function(brush_t,brush_t) isFriend = null;
		void function(brush_t,brush_t) isBorder = null;
	}
	struct RmeTilesetsParser
	{
		const(char)* data;

		void function(brush_t,brush_tt) isBrushType = null;
		void function(tileset_t,brush_t) isTilesetBrush = null;
		void function(tileset_t,ItemId) isTilesetItem = null;
	}
	struct RmeParser
	{
		const(char)* data_path;

		RmeBorderParser border;
		RmeDoodadsParser doodads;
		RmeGroundsParser grounds;
		RmeWallsParser walls;
		RmeTilesetsParser tilesets;
	}

	/**
	* High level parse data-dir function function
	*/
	void rmeParse(ref RmeParser args)
	{
		auto data_path = to!string(args.data_path);
		enforce(data_path.exists, text("Path \"",data_path,"\" does not exists"));
		enforce(data_path.isDir, text("Path \"",data_path,"\" is not a valid directory"));


		{
			auto file_path = buildPath(data_path,"borders.xml");
			enforce(file_path.exists, text("File \"",file_path,"\" doesn't exists"));
			enforce(file_path.isFile, text("\"",file_path,"\" is not a file"));
			args.border.data = readText(file_path).toStringz;
			rmeParseBorders(args.border);
		}
		{
			auto file_path = buildPath(data_path,"doodads.xml");
			enforce(file_path.exists, text("File \"",file_path,"\" doesn't exists"));
			enforce(file_path.isFile, text("\"",file_path,"\" is not a file"));
			args.doodads.data = readText(file_path).toStringz;
			rmeParseDoodads(args.doodads);
		}
		{
			auto file_path = buildPath(data_path,"grounds.xml");
			enforce(file_path.exists, text("File \"",file_path,"\" doesn't exists"));
			enforce(file_path.isFile, text("\"",file_path,"\" is not a file"));
			args.grounds.data = readText(file_path).toStringz;
			rmeParseGrounds(args.grounds);
		}
		{
			auto file_path = buildPath(data_path,"walls.xml");
			enforce(file_path.exists, text("File \"",file_path,"\" doesn't exists"));
			enforce(file_path.isFile, text("\"",file_path,"\" is not a file"));
			args.walls.data = readText(file_path).toStringz;
			rmeParseWalls(args.walls);
		}
		{
			auto file_path = buildPath(data_path,"tilesets.xml");
			enforce(file_path.exists, text("File \"",file_path,"\" doesn't exists"));
			enforce(file_path.isFile, text("\"",file_path,"\" is not a file"));
			args.tilesets.data = readText(file_path).toStringz;
			rmeParseTilesets(args.tilesets);
		}
	}

	/**
	* Parse borders.xml file
	*/
	void rmeParseBorders(in ref RmeBorderParser args)
	{
		auto file = to!string(args.data);
//		check(file);
		DocumentParser xml;
		xml = new DocumentParser(file);
		xml.onStartTag["border"] = (ElementParser xml)
		{
			xml.onStartTag["borderitem"] = (ElementParser xml)
			{
				auto edge = xml.tag.attr["edge"].toStringz;
				auto item_id = to!uint(xml.tag.attr["item"]);
				if( args.isEdge !is null )
				{
					args.isEdge(item_id, edge);
				}
			};
			xml.parse();
		};
		xml.parse();
	}
	/**
	* Parse doodads.xml file
	*/
	void rmeParseDoodads(in ref RmeDoodadsParser args)
	{
		parse_brush(args);
	}
	/**
	* Parse grounds.xml file
	*/
	void rmeParseGrounds(in ref RmeGroundsParser args)
	{
		parse_brush(args);
	}
	/**
	* Parse walls.xml file
	*/
	void rmeParseWalls(in ref RmeWallsParser args)
	{
		parse_brush(args);
	}
	/**
	* Parse tilesets.xml file
	*/
	void rmeParseTilesets(in ref RmeTilesetsParser args)
	{
		auto str = to!string(args.data);
		auto xml = new DocumentParser(str);
		xml.onStartTag["tileset"] = (ElementParser xml)
		{
			auto tag1 = xml.tag.attr["name"];

			xml.onStartTag[null] = (ElementParser xml)
			{
				auto tag2 = xml.tag.name;

				if( tag2.cmp("item") == 0 )
				{
					ItemId[] ids;
					if ( "id" in xml.tag.attr )
					{
						ids ~= to!ItemId(xml.tag.attr["id"]);
					}
					else
					{
						auto id_start = to!ItemId(xml.tag.attr["fromid"]);
						auto id_end = ("toid" in xml.tag.attr) ? to!ItemId(xml.tag.attr["toid"]) : id_start+1;

						foreach( id; iota(id_start,id_end+1) )
						{
							ids ~= id;
						}
					}
					foreach( id; ids )
					{
						if( args.isTilesetItem !is null )
						{
							args.isTilesetItem(tag1.toStringz, id);
						}
					}
				}
				else if( tag2.cmp("brush") == 0 )
				{
					auto name = xml.tag.attr["name"];
					if( args.isTilesetBrush !is null )
					{
						args.isTilesetBrush(tag1.toStringz, name.toStringz);
					}
				}
				else
				{
					if( args.isBrushType !is null )
					{
						args.isBrushType(tag1.toStringz, tag2.toStringz);
					}
				}
			};

			xml.parse();
		};
		xml.parse();
	}
}

private:
template isBrush(T)
{
	T var;
	enum bool isBrush =
		is(typeof(var.data) == const(char*))// dont' ask my why not const(char)*
		&&
		isSomeFunction!(var.isBrushType) && is(ParameterTypeTuple!(var.isBrushType) == TypeTuple!(brush_t,brush_tt))
	;
}
void parse_brush(Parser)(Parser args) if( isBrush!Parser )
{
	auto str = to!string(args.data);
//	check(str);
	auto xml = new DocumentParser(str);
	xml.onStartTag["brush"] = (ElementParser xml)
	{
		auto name =  xml.tag.attr["name"];
		auto type = xml.tag.attr["type"];
		if( args.isBrushType !is null )
		{
			args.isBrushType(name.toStringz,type.toStringz);
		}

		xml.onStartTag["carpet"] = (ElementParser xml)
		{
			ItemId[] ids;
			if( "id" !in xml.tag.attr )
			{
				xml.onStartTag["item"] = (ElementParser xml)
				{
					ids ~= to!ItemId(xml.tag.attr["id"]);
				};
				xml.parse();
			}
			else
			{
				ids ~= to!ItemId(xml.tag.attr["id"]);
			}

			Nullable!string align_;

			if( "align" in xml.tag.attr )
			{
				align_ = xml.tag.attr["align"];
			}
			foreach( id; ids )
			{
				if( !align_.isNull )
				{
					if( args.isEdge !is null )
					{
						args.isEdge(id, align_.get.toStringz);
					}
				}
				if( args.isBrush !is null )
				{
					args.isBrush(id, name.toStringz);
				}
			}
		};
		xml.onStartTag["table"] = (ElementParser xml)
		{
			ItemId[] ids;

			xml.onStartTag["item"] = (ElementParser xml)
			{
				ids ~= to!ItemId(xml.tag.attr["id"]);
			};
			xml.parse();

			Nullable!string align_;

			if( "align" in xml.tag.attr )
			{
				align_ = xml.tag.attr["align"];
			}

			foreach( id; ids )
			{
				if( !align_.isNull )
				{
					if( args.isEdge !is null )
					{
						args.isEdge(id, align_.get.toStringz);
					}
				}
				if( args.isBrush !is null )
				{
					args.isBrush(id, name.toStringz);
				}
			}
		};
		xml.onStartTag["wall"] = (ElementParser xml)
		{
			ItemId[] ids;
			auto wall_type = xml.tag.attr["type"];

			xml.onStartTag["item"] = (ElementParser xml)
			{
				ids ~= to!ItemId(xml.tag.attr["id"]);
			};

			xml.parse();

			foreach( id; ids )
			{
				if( args.isWall !is null )
				{
					args.isWall(id, wall_type.toStringz);
				}
				if( args.isNamed !is null )
				{
					args.isNamed(id, name.toStringz);
				}
			}
		};
		xml.onStartTag["friend"] = (ElementParser xml)
		{
			auto key = "name";
			if( key !in xml.tag.attr )
			{
				key = "id";
			}
			auto relation = xml.tag.attr[key];
			if( args.isFriend !is null )
			{
				args.isFriend(relation.toStringz, name.toStringz);
			}
		};
		xml.onStartTag["border"] = (ElementParser xml)
		{
			auto align_ = xml.tag.attr["align"];

			if( "to" in xml.tag.attr )
			{
				if( args.isBorder !is null )
				{
					args.isBorder(name.toStringz, xml.tag.attr["to"].toStringz);
				}
			}

			xml.onStartTag["borderitem"] = (ElementParser xml)
			{
				auto edge = xml.tag.attr["edge"];
				auto item_id = to!ItemId(xml.tag.attr["item"]);

				if( args.isEdge !is null )
				{
					args.isEdge(item_id, edge.toStringz);
				}

				if( args.isBrush !is null )
				{
					args.isBrush(item_id, name.toStringz);
				}
			};
			xml.parse();
		};
		xml.parse();
	};
	xml.parse();
}
