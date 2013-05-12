module tool;
import rme;

import std.stdio;
import std.conv;
import std.range;
import std.string;
import std.file;
import tfs;

string[][string] brushTypes;
string[][ItemId] edges;

static string[][ItemId] items;

auto keystore(A...)(ItemId id, A args)
{
	items[id] ~= text(args);
}

brush_t[][brush_t] can_border;
brush_t[][brush_t] relates;
brush_tt[][brush_t] is_grouped;

brush_t[][ItemId] is_brush;

brush_tt[][tileset_t] makes_brushtype;
tileset_t[][brush_t] brush_makes_tileset;
brush_t[][ItemId] item_makes_tileset;


void main()
{
/*	RmeParser pd;
	
	pd.data_path = r"C:\Users\Marcin\Documents\GitHub\nawia-private\rme\data\954";
	
// === different types of tiles edges
	pd.border.isEdge = (ItemId item,edge_t edge)
	{
		keystore(item,"is edge",edge);
	};
// === over tile (i.e. stones)
	pd.doodads.isEdge = (ItemId item,edge_t edge)
	{
		keystore(item,"is edge",edge);
	};
// === floor
	pd.grounds.isEdge = (ItemId item,edge_t edge)
	{
		keystore(item,"is edge",edge);
	};
// === walls
	pd.walls.isEdge = (ItemId item,edge_t edge)
	{
		keystore(item,"is edge",edge);
	};
	
	pd.doodads.isWall = (ItemId,wall_t)
	{
		keystore(ItemId,"is wall",wall_t);
	};
	pd.grounds.isWall = (ItemId,wall_t)
	{
		keystore(ItemId,"is wall",wall_t);
	};
	pd.walls.isWall = (ItemId,wall_t)
	{
		keystore(ItemId,"is wall",wall_t);
	};
	
// === can border with another brush	
	pd.doodads.isBorder = (brush_t b1,brush_t b2)
	{
		can_border[b1] ~= b2;
		can_border[b2] ~= b1;
	};
	pd.grounds.isBorder = (brush_t b1,brush_t b2)
	{
		can_border[b1] ~= b2;
		can_border[b2] ~= b1;
	};
	pd.walls.isBorder = (brush_t b1,brush_t b2)
	{
		can_border[b1] ~= b2;
		can_border[b2] ~= b1;
	};
	
// === is related to another brush
	pd.doodads.isFriend = (brush_t b1,brush_t b2)
	{
		relates[b1] ~= b2;
		relates[b2] ~= b1;
	};
	pd.doodads.isFriend = (brush_t b1,brush_t b2)
	{
		relates[b1] ~= b2;
		relates[b2] ~= b1;
	};
	pd.doodads.isFriend = (brush_t b1,brush_t b2)
	{
		relates[b1] ~= b2;
		relates[b2] ~= b1;
	};

// === brush_tt // brush_t // item	
	pd.doodads.isBrushType  = (brush_t b, brush_tt t)
	{
		is_grouped[b] ~= t;
	};
	pd.grounds.isBrushType  = (brush_t b, brush_tt t)
	{
		is_grouped[b] ~= t;
	};
	pd.walls.isBrushType  = (brush_t b, brush_tt t)
	{
		is_grouped[b] ~= t;
	};
	
	pd.doodads.isBrush  = (ItemId i, brush_t b)
	{
		is_brush[i] ~= b;
	};
	pd.grounds.isBrush  = (ItemId i, brush_t b)
	{
		is_brush[i] ~= b;
	};
	pd.walls.isBrush  = (ItemId i, brush_t b)
	{
		is_brush[i] ~= b;
	};
	
// === brush_tt // tileset_t // brush_t // items
	pd.tilesets.isBrushType  = (tileset_t t, brush_tt tt)
	{
		makes_brushtype[t] ~= tt;
	};
	pd.tilesets.isTilesetBrush  = (tileset_t t, brush_t b)
	{
//		writeln(to!string(t),to!string(b));
		brush_makes_tileset[b] ~= t;
	};
	pd.tilesets.isTilesetItem  = (tileset_t t, ItemId i)
	{
//		writeln(to!string(b));
		item_makes_tileset[i] ~= t;
	};
	
	rmeParse(pd);
	
/*
	brush_t[][brush_t] can_border;
	brush_t[][brush_t] relates;
	brush_tt[][brush_t] is_grouped;
	
	brush_t[][ItemId] is_brush;
	
	brush_tt[][tileset_t] makes_brushtype;
	tileset_t[][brush_t] brush_makes_tileset;
	brush_t[][ItemId] item_makes_tileset;
"""
	
	foreach( item,brush; is_brush )
	{
		keystore(item,"makes brush",brush);
	}
//	if( edge )
//	{
//		if( BlockSolid,BlockProjectile,AlwaysOnTop )
//			return high;
//		else
//			return low;
//	}
	
	foreach( k,v; items )
	{
		writeln(k,": ",v);
	}
	writeln("~~~ Done ~~~");
*/
TfsItemsXmlParser params;
params.content = readText(r"C:\Users\Marcin\Documents\GitHub\nawia-private\data\items\items.xml").toStringz;
tfsParseItemsXml(params);
}
