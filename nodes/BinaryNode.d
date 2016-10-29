module parser.nodes.BinaryNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class BinaryNode : Node
{
	Node left;
	Node right;

	this(TokenLocation location, Node left, Node right)
	{
		this.location = location;
		this.left = left;
		this.right = right;
	}

	override void each(void function(ref Node) action)
	{
		//Call action on each node
		action(left);
		action(right);

		//Pass along to children
		left.each(action);
		right.each(action);
	}

	override void analyzeVariables(Environment e)
	{
		left.analyzeVariables(e);
		right.analyzeVariables(e);
	}

	override bool isStatic()
	{
		//Only static if left-hand and right-hand sides are static
		return left.isStatic() && right.isStatic();
	}

	override SemanticValue computeStaticValue()
	{
		//This won't be called unless we're static

		//Compute values
		SemanticValue leftValue = left.computeStaticValue();
		SemanticValue rightValue = right.computeStaticValue();

		//Assume we're working with numbers
		double result = leftValue.value.num + rightValue.value.num;

		//Create a new semantic type
		SemanticType type = new SemanticType(DataType.Num);

		//Add the result to the value
		DataValue value;
		value.num = result;

		//Return the semantic value
		return  new SemanticValue(type, value);
	}
}