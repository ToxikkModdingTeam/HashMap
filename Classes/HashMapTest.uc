
class HashMapTest extends CRZMutator
	DependsOn(StructMap);

struct TestStruct extends StructMap.MappableStruct
{
	var float value;
};

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(3.0, false, 'Test1');
	SetTimer(6.0, false, 'Test2');
}

function Test1()
{
	local ObjMap map;
	local ObjPair p;
	local int i;

	`Log("-- creating Object map with random stuff");
	map = class'ObjMap'.static.create();
	map.set("forty-two", new(None,"FortyTwo") class'HashMapTestObject');
	map.set("blabla", new(None,"Blabla") class'HashMapTestObject');
	map.set("pi", new(None,"3.1415926") class'HashMapTestObject');
	map.set("null", None);
	map.set("myself", map);
	PrintObjMap(map);

	`Log("-- deleting 'null'");
	`Log(map.remove("null"));
	PrintObjMap(map);

	`Log("-- deleting 'forty-two'");
	`Log(map.remove("forty-two"));
	PrintObjMap(map);

	`Log("-- deleting 'test'");
	`Log(map.remove("test"));

	`Log("-- adding lots of elements for resize");
	for ( i=0; i<20; i++ )
		map.set("elem"$i, new(None,"Elem"$i) class'HashMapTestObject');
	PrintObjMap(map);

	`Log("-- iterating and removing (map should shrink in the middle - expect the unexpected)");
	for ( map.start(); map.next(p); map.void() )
	{
		`Log("removing " $ p.key $ " => " $ (p.value != None ? String(p.value.Name) : "None"));
		map.remove(p.key);
	}
	`Log("-- done");
	PrintObjMap(map);

	`Log("-- clearing");
	map.clear();
	PrintObjMap(map);
}

function PrintObjMap(ObjMap map)
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

/*
function Test2()
{
	local StructMap map;
	local TestStruct p;
	local int i;

	`Log("-- creating Struct map with random stuff");
	map = class'StructMap'.static.create();
	p = MakeTestStruct(42);
	map.set("forty-two", p);
	p = MakeTestStruct(1);
	map.set("one", p);
	p = MakeTestStruct(2)
	map.set("two", p);
	p = MakeTestStruct(3);
	map.set("three", p);
	p = MakeTestStruct(3.1415926);
	map.set("pi", p);
	PrintStructMap(map);

	`Log("-- deleting 'three'");
	ClearTestStruct(p);
	map.remove("three", p);
	`Log("removed " $ p.key $ " => " $ p.value);
	PrintStructMap(map);

	`Log("-- deleting 'forty-two'");
	ClearTestStruct(p);
	map.remove("forty-two", p);
	`Log("removed " $ p.key $ " => " $ p.value);
	PrintStructMap(map);

	`Log("-- deleting 'test'");
	ClearTestStruct(p);
	map.remove("test", p);
	`Log("removed " $ p.key $ " => " $ p.value);

	`Log("-- adding lots of elements for resize");
	for ( i=20; i<40; i++ )
	{
		p = MakeTestStruct(i);
		map.set("elem"$i, p);
	}
	PrintStructMap(map);

	`Log("-- iterating and removing");
	for ( map.start(); map.next(p); map.void() )
	{
		`Log("removing " $ p.key $ " => " $ p.value);
		map.remove(p.key);
	}
	`Log("-- done");
	PrintStructMap(map);
}

function TestStruct MakeTestStruct(float val)
{
	local TestStruct s;
	s.value = val;
	return s;
}

function ClearTestStruct(out TestStruct p)
{
	p.key = "<CLEAR>";
	p.value = -1337;
}

function PrintStructMap(StructMap map)
{
	local TestStruct p;
	`Log("size=" $ map.table.length $ " fill=" $ map.fill $ " {");
	for ( map.start(); map.next(p); map.void() )
		`Log("   " $ p.key $ " => " $ TestStruct(p).value);
	`Log("}");
}
*/
