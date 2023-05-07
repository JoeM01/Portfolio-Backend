import unittest
import json
from updateVisitorCounter import lambda_handler


class TestLambdaFunction(unittest.TestCase):

    def test_lambda_handler(self):
        event = {}  # You can define a specific event input if needed
        context = {}  # You can define a specific context input if needed

        response = lambda_handler(event, context)

        # Check if the status code is 200
        self.assertEqual(response["statusCode"], 200)

        # Check if the correct headers are set
        self.assertEqual(response["headers"]["Access-Control-Allow-Origin"], "*")
        self.assertEqual(response["headers"]["Access-Control-Allow-Headers"], "Content-Type")
        self.assertEqual(response["headers"]["Access-Control-Allow-Methods"], "GET")

        # Check if the response body is a valid JSON string and contains the "count" key
        body = json.loads(response["body"])
        self.assertIn("count", body)


if __name__ == "__main__":
    unittest.main()
