
class MapBase extends Object;

CONST DEFAULT_SIZE = 10;
CONST ENLARGE_AT = 0.75;
CONST SHRINK_AT = 0.15;
CONST RESIZE_MULT = 2;
CONST RESIZE_DIV = 2;

var int fill;

var int it_1;
var int it_2;

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

function void() {}
