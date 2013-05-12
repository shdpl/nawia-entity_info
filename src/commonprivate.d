module commonprivate;
private {
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
