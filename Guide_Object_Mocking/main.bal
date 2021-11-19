import ballerina/io;
import ballerina/http;
import ballerina/regex;

http:Client clientEndpoint = check new ("https://api.chucknorris.io/jokes/");

// This function performs a `get` request to the Chuck Norris API and returns a random joke 
// or an error if the API invocations fail.
function getRandomJoke(string name, string category = "food") returns @tainted string|error {
    string replacedText = "";
    http:Response response = check clientEndpoint->get("/categories");

    // Check if the provided category is available

    if (response.statusCode == http:STATUS_OK) {
        json[] categories = <json[]>check response.getJsonPayload();

        if (!isCategoryAvailable(categories, category)) {
            error err = error("'" + category + "' is not a valid category.");
            io:println(err.message());
            return err;
        } else {
            // Get a random joke from the provided category
            response = check clientEndpoint->get("/random?category=" + category);

            if (response.statusCode == http:STATUS_OK) {
                json payload = check response.getJsonPayload();
                json joke = check payload.value;

                replacedText = regex:replaceAll(joke.toString(), "Chuck Norris", name);
                return replacedText;

            } else {
                return createError(response);
            }
        }

    } else {
        return createError(response);
    }

}
