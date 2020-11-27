import ballerina/io;

public function main() {
    io:println("Hello World!");
}

//
// FUNCTIONS
//

// Returns (int)
public function intAdd(int a, int b) returns (int) {
    return a + b;
}

// Returns (string)
public function stringAdd(string str) returns (string) {
    return "test_" + str;
}

// Returns (float)
public function floatAdd(float c, float d) returns (float) {
    return c + d;
}

// Call mocked function
public function callIntAdd(int x, int y) returns (int) {
    return intAdd(x, y);
}

// Function with varargs
public function intAddMultiple((any|error)... intValues) returns (int) {
    int sum = 0;

    foreach var arg in intValues {
        if (arg is int) {
            sum += arg;
        }
    }

    return  sum;
}
