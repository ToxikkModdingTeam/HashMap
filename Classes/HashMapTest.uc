
class HashMapTest extends CRZMutator
	DependsOn(HashMap);

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(3.0, false, 'Test1');
}

function Test1()
{
	local HashMap map;
	local xPair p;
	local int i;

	`Log("-- creating Object map with random stuff");
	map = class'HashMap'.static.create();
	map.set("forty-two", new(None,"FortyTwo") class'HashMapTestObject');
	map.set("blabla", new(None,"Blabla") class'HashMapTestObject');
	map.set("pi", new(None,"3.1415926") class'HashMapTestObject');
	map.set("null", None);
	map.set("myself", map);
	PrintMap(map);

	`Log("-- deleting 'null'");
	`Log(map.remove("null"));
	PrintMap(map);

	`Log("-- deleting 'forty-two'");
	`Log(map.remove("forty-two"));
	PrintMap(map);

	`Log("-- deleting 'test'");
	`Log(map.remove("test"));

	`Log("-- adding lots of elements for resize");
	for ( i=0; i<20; i++ )
		map.set("elem"$i, new(None,"Elem"$i) class'HashMapTestObject');
	PrintMap(map);

	`Log("-- iterating and removing (map should shrink in the middle - expect the unexpected)");
	for ( map.start(); map.next(p); map.thirdwheel() )
	{
		`Log("removing " $ p.key $ " => " $ (p.value != None ? String(p.value.Name) : "None"));
		map.remove(p.key);
	}
	`Log("-- done");
	PrintMap(map);

	`Log("-- clearing");
	map.clear();
	PrintMap(map);
}

function PrintMap(HashMap map)
{
	local int i,p;
	local String s;

	`Log("size=" $ map.table.length $ " fill=" $ map.fill $ " [");
	for ( i=0; i<map.table.length; i++ )
	{
		s = "   " $ i $": ";
		for ( p=0; p<map.table[i].list.length; p++ )
			s $= " " $ map.table[i].list[p].key $ "=>" $ (map.table[i].list[p].value != None ? String(map.table[i].list[p].value.Name) : "None") $ " , ";
		`Log(s);
	}
	`Log("]");
}
