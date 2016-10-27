module parse.nodes.NumNode;
import parse.nodes.node;

class NumNode : Node
{
	double num;
	this(TokenLocation location, string num)
	{
		this.location = location;
		this.num = to!double(num); 
	}	

	override void print()
	{
		write(num);
	}
}
