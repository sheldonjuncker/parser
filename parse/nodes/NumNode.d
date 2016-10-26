module parse.nodes.NumNode;
import parse.nodes.node;

class NumNode : Node
{
	double num;
	this(string num)
	{
		this.num = to!double(num); 
	}	

	override void print()
	{
		write(num);
	}
}
