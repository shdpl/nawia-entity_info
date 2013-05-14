/**
 * Authors: Nawia Team <development@nawia.net>
 * License: GNU Lesser General Public License
 * Todo: Replace semi-c API with D API + C-bindings
 */
module commonprivate;
private {
	import std.string : text,toLower;
	import std.exception : enforce;

	import commonpublic;
}

alias const(char)* cstring;

void callback(FuncType,Args...)(FuncType func, Args args)
{
	if( func !is null )
	{
		func(args);
	}
}
void callbackIds(FuncType,Args...)(FuncType func, ItemId[] ids, Args args)
{
	if( func !is null )
	{
		foreach( id; ids )
		{
			func(id,args);
		}
	}
}


bool tfsBool(string value)
{
	switch( value.toLower )
	{
		case "0":
		case "false":
			return false;
		break;
		case "1":
		case "true":
			return true;
		break;
		default:
			enforce(false,text("Could not parse ",value," as bool."));
	}
	assert(0);
}
