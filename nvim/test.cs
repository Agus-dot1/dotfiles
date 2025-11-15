using System;

public class TestClass
{
    public void SimpleMethod()
    {
        Console.WriteLine("Hello");
    }

    [Obsolete]
    public static async Task<int> ComplexMethod(string param1, int param2)
    {
        return await Task.FromResult(param1.Length + param2);
    }

    private override string ToString()
    {
        return "Test";
    }
}