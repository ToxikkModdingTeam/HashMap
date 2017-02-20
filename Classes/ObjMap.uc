
class ObjMap extends Object;

CONST DEFAULT_SIZE = 10;
CONST ENLARGE_AT = 0.75;
CONST SHRINK_AT = 0.15;
CONST RESIZE_MULT = 2;
CONST RESIZE_DIV = 2;

struct ObjPair
{
	var String key;
	var Object value;
};

struct ObjTableItem
{
	var array<ObjPair> list;
};

var array<ObjTableItem> table;

var int fill;

var int it_1;
var int it_2;


//================================================
// Init
//================================================

function init()
{
	table.length = 0;
	table.length = DEFAULT_SIZE;
	fill = 0;
}

static function ObjMap create()
{
	local ObjMap map;
	map = new(None) class'ObjMap';
	map.init();
	return map;
}


//================================================
// Get Set
//================================================

function set(String key, Object value)
{
	local int i,p;
	local ObjPair pair;

	i = hash(key) % table.length;
	p = table[i].list.Find('key', key);
	if ( p != INDEX_NONE )
		table[i].list[p].value = value;
	else
	{
		pair.key = key;
		pair.value = value;
		table[i].list.AddItem(pair);

		if ( table[i].list.length == 1 )
		{
			fill++;
			if ( float(fill) / float(table.length) > ENLARGE_AT )
				resize(table.length * RESIZE_MULT);
		}
	}
}

function Object get(String key)
{
	local int i,p;

	i = hash(key) % table.length;
	p = table[i].list.Find('key', key);
	if ( p != INDEX_NONE )
		return table[i].list[p].value;

	return None;
}


//================================================
// Iterators
//================================================

/*
	local ObjPair pair;

	map.start();
	while ( map.hasNext() )
	{
		map.next(pair);
		//...
	}

	map.start();
	while ( map.next(pair) )
	{
		//...
	}

	for ( map.start(); map.next(pair); map.thirdwheel(); )
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

function bool next(out ObjPair pair)
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

function Object remove(String key)
{
	local int i,p;
	local Object obj;

	i = hash(key) % table.length;
	p = table[i].list.find('key', key);
	if ( p != INDEX_NONE )
	{
		obj = table[i].list[p].value;

		if ( it_1 == i && it_2 > p )
			it_2--;

		table[i].list.Remove(p,1);
		if ( table[i].list.length == 0 )
		{
			fill--;
			if ( float(fill) / float(table.length) < SHRINK_AT )
				resize(table.length / RESIZE_DIV);
		}

		return obj;
	}

	return None;
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

CONST HASH_START = 5381;

function int hash(String key)
{
	local int n, i, h;
	h = HASH_START;
	n = Len(key);
	for ( i=0; i<n; i++ )
		h += (h<<5) + Asc(Mid(key,i,1));
	return (h < 0) ? (-h) : h;
}

function resize(int newSize)
{
	local ObjMap newMap;
	local ObjPair pair;

	if ( newSize < DEFAULT_SIZE )
		newSize = DEFAULT_SIZE;
	if ( newSize == table.length )
		return;

	newMap = class'ObjMap'.static.create();
	newMap.table.length = newSize;
	for ( start(); next(pair); thirdwheel() )
		newMap.set(pair.key, pair.value);

	table = newMap.table;
	fill = newMap.fill;
}

function void() {}
function thirdwheel() {}
