module parser.nodes.NumNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class NumNode : Node
{
	double num;
	this(TokenLocation location, double num)
	{
		this.location = location;
		this.num = num; 
	}	

	override void print(int tabs=0)
	{
		write(num);
	}

	override bool isStatic()
	{
		//We know the value of a number at compile time
		return true;
	}


	override SemanticValue computeStaticValue()
	{
		//This won't be called unless we're static

		//Create a new number semantic type
		SemanticType type = new SemanticType(DataType.Num);

		//Add the result to the value
		DataValue value;
		value.num = num;

		//Return the semantic value
		return  new SemanticValue(type, value);
	}
}
