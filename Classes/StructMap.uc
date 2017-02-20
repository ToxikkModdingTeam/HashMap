
class StructMap extends MapBase;

struct MappableStruct
{
	var String key;
};

struct StructTableItem
{
	var array<MappableStruct> list;
};

var array<StructTableItem> table;


//================================================
// Init
//================================================

function init()
{
	table.length = 0;
	table.length = DEFAULT_SIZE;
	fill = 0;
}

static function StructMap create()
{
	local StructMap map;
	map = new(None) class'StructMap';
	map.init();
	return map;
}


//================================================
// Get Set
//================================================

function set(String key, out MappableStruct value)
{
	local int i,p;

	value.key = key;

	i = hash(key) % table.length;
	p = table[i].list.Find('key', key);
	if ( p != INDEX_NONE )
		table[i].list[p] = value;
	else
	{
		table[i].list.AddItem(value);

		if ( table[i].list.length == 1 )
		{
			fill++;
			if ( float(fill) / float(table.length) > ENLARGE_AT )
				resize(table.length * RESIZE_MULT);
		}
	}
}

function bool get(String key, out MappableStruct value)
{
	local int i,p;

	i = hash(key) % table.length;
	p = table[i].list.Find('key', key);
	if ( p != INDEX_NONE )
	{
		value = table[i].list[p];
		return true;
	}
	return false;
}


//================================================
// Iterators
//================================================

/*
	local MappableStruct item;

	map.start();
	while ( map.hasNext() )
	{
		map.next(item);
		//...
	}

	map.start();
	while ( map.next(item) )
	{
		//...
	}

	for ( map.start(); map.next(item); map.void(); )
	{
		//...
	}
*/

function start()
{
	for ( it_1=0; it_1<table.length; it_1++ )
	{
		if ( table[it_1].list.length > 0 )
		{
			it_2 = 0;
			return;
		}
	}
}

function bool hasNext()
{
	return (it_1 < table.length && it_2 < table[it_1].list.length);
}

function bool next(out MappableStruct pair)
{
	if ( hasNext() )
	{
		pair = table[it_1].list[it_2];

		if ( it_2 >= table[it_1].list.length-1 )
		{
			for ( it_1=it_1+1; it_1<table.length; it_1++ )
			{
				if ( table[it_1].list.length > 0 )
				{
					it_2 = 0;
					break;
				}
			}
		}
		else
			it_2++;

		return true;
	}

	return false;
}


//================================================
// Removing
//================================================

function bool remove(String key, out MappableStruct value)
{
	local int i,p;

	i = hash(key) % table.length;
	p = table[i].list.find('key', key);
	if ( p != INDEX_NONE )
	{
		value = table[i].list[p];

		if ( it_1 == i && it_2 > p )
			it_2--;

		table[i].list.Remove(p,1);
		if ( table[i].list.length == 0 )
		{
			fill--;
			if ( float(fill) / float(table.length) < SHRINK_AT )
				resize(table.length / RESIZE_DIV);
		}

		return true;
	}

	return false;
}

function clear()
{
	table.length = 0;
	table.length = DEFAULT_SIZE;
	fill = 0;
}


//================================================
// Utils
//================================================

function resize(int newSize)
{
	local StructMap newMap;
	local MappableStruct pair;

	if ( newSize < DEFAULT_SIZE )
		newSize = DEFAULT_SIZE;
	if ( newSize == table.length )
		return;

	newMap = class'StructMap'.static.create();
	newMap.table.length = newSize;
	for ( start(); next(pair); void() )
		newMap.set(pair.key, pair);

	table = newMap.table;
	fill = newMap.fill;
}
