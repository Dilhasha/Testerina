import ballerina/test;
import function_mocking.mock2;

(any|error)[] outputs = [];
int counter = 0;

//
// MOCK FUNCTION OBJECTS
//

@test:Mock {
    functionName : "intAdd"
}
test:MockFunction mock_intAdd = new();

@test:Mock {
    functionName : "stringAdd"
}
test:MockFunction mock_stringAdd = new();

@test:Mock {
    functionName: "floatAdd"
}
test:MockFunction mock_floatAdd = new();

@test:Mock {
    moduleName : "intg_tests/function_mocking.mock2",
    functionName : "intAdd2"
}
test:MockFunction mock2_intAdd = new();

@test:Mock {
    functionName : "intAdd3"
}
test:MockFunction mock_intAdd3 = new();

@test:Mock {
    functionName : "foo"
}
test:MockFunction mock_foo = new();

//
//  MOCK FUNCTIONS
//

public function mockIntAdd1(int x, int y) returns (int) {
    return x - y;
}

public function mockIntAdd2(int a, int b) returns (int) {
    return a * b;
}

public function mockIntAdd3(int a, int b) returns (float) {
    return 10.0;
}

public function mockIntAdd4(int a) returns (int) {
    return a;
}

public function mockIntAdd5((any|error)... args) returns (int) {
    int sum = 0;

    foreach var arg in args {
        if (arg is int) {
            sum -= arg;
        }
    }

    return  sum;
}

public function mockStringAdd(string str1) returns (string) {
    return "Hello " + str1;
}

public function mockFloatAdd(float a, float b) returns (float) {
    return a - b;
}

public function bar(any a) returns @tainted string {
    return "bye";
}

//
//  MOCK FUNCTIONS
//

@test:Mock {
    functionName : "intAdd6"
}
function mockIntAdd6(int a, int b, int c) returns (int) {
    return a - b - c;
}

@test:Mock {
    functionName : "intSubtract7",
    moduleName : "function_mocking.mock2"
}
function mockIntSubtract7(int a, int b, int c) returns (int) {
    return a + b + c;
}

//
// TESTS
//

@test:Config {}
public function call_Test1() {
    // IntAdd
    test:when(mock_intAdd).call("mockIntAdd1");
    test:assertEquals(intAdd(10, 6), 4);
    test:assertEquals(callIntAdd(10, 6), 4);

    // StringAdd
    test:when(mock_stringAdd).call("mockStringAdd");
    test:assertEquals(stringAdd("Ibaqu"), "Hello Ibaqu");

     // FloatAdd
     test:when(mock_floatAdd).call("mockFloatAdd");
     test:assertEquals(floatAdd(10.6, 4.5), 6.1);
}

@test:Config {}
public function call_Test2() {
    // Set which function to call
    test:when(mock_intAdd).call("mockIntAdd1");
    test:assertEquals(intAdd(10, 6), 4);

    // Switch function to call
    test:when(mock_intAdd).call("mockIntAdd2");
    test:assertEquals(intAdd(10, 6), 60);

    // Switch again
    test:when(mock_intAdd).call("mockIntAdd1");
    test:assertEquals(intAdd(10, 6), 4);
}

@test:Config {}
public function call_Test3() {
    test:when(mock_intAdd).call("invalidMockFunction");
    test:assertEquals(intAdd(10, 6), 4);
}

@test:Config {}
public function call_Test4() {
    test:when(mock_intAdd).call("mockIntAdd3");
    test:assertEquals(intAdd(10, 6), 4);
}

@test:Config {}
public function call_Test5() {
    test:when(mock_intAdd).call("mockIntAdd4");
    test:assertEquals(intAdd(10, 6), 4);
}

@test:Config {}
public function call_Test6() {
    TestClass testClass = new();
    test:when(mock_intAdd).call("mockIntAdd1");
    int value = testClass.add(10, 4);
    test:assertEquals(value, 6);
}

@test:Config {}
public function call_Test7() {
    test:when(mock2_intAdd).call("mockIntAdd2");
    test:assertEquals(mock2:intAdd2(10, 5), 50);
}

@test:Config {}
public function call_Test8() {
    test:when(mock_intAdd3).call("mockIntAdd5");
    test:assertEquals(intAdd3(1, 3, 5), -9);
}

@test:Config {}
public function call_Test9() {
    test:when(mock_foo).call("bar");
    test:assertEquals(foo("testing"), "bye");
}

@test:Config {}
public function thenReturn_Test1() {
    test:when(mock_intAdd).thenReturn(5);
    test:assertEquals(intAdd(10, 4), 5);

    test:when(mock_stringAdd).thenReturn("testing");
    test:assertEquals(stringAdd("string"), "testing");

    test:when(mock_floatAdd).thenReturn(10.5);
    test:assertEquals(floatAdd(10, 5), 10.5);
}

@test:Config {}
public function withArguments_Test1() {
    test:when(mock_intAdd).withArguments(20, 14).thenReturn(100);
    test:assertEquals(intAdd(20, 14), 100);

    test:when(mock_stringAdd).withArguments("string1").thenReturn("test");
    test:assertEquals(stringAdd("string1"), "test");
}

@test:Config {}
public function callOriginal_Test1() {
    // IntAdd
    test:when(mock_intAdd).callOriginal();
    test:assertEquals(intAdd(10, 6), 16);
    test:assertEquals(callIntAdd(10, 6), 16);

    // StringAdd
    test:when(mock_stringAdd).callOriginal();
    test:assertEquals(stringAdd("Ibaqu"), "test_Ibaqu");

    // FloatAdd
    test:when(mock_floatAdd).callOriginal();
    test:assertEquals(floatAdd(10.6, 4.5), 15.1);
}

@test:Config {}
public function callOriginal_Test3() {
    test:when(mock2_intAdd).callOriginal();
    test:assertEquals(mock2:intAdd2(10, 5), 15);
}

@test:Config {}
public function mockReplace_Test1() {
    test:assertEquals(intAdd6(10, 3, 2), 5);
}

@test:Config {}
public function mockReplace_Test2() {
    test:assertEquals(mock2:intSubtract7(10, 3, 2), 15);
}
