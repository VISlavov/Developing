package stuff1;

public class MultiplyOperation extends CommonOperation implements OperationInterface{

	public MultiplyOperation(int operand1, int operand2) {
		super(operand1, operand2);
	}

	@Override
	public int execute() {
		return operand1 * operand2;
	}
}
