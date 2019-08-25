module Lucky::RequestExpectations
  def send_json(status, **expected)
    SendJsonExpectation.new(status, expected.to_json)
  end

  struct SendJsonExpectation
    private getter expected_status, expected_json

    def initialize(@expected_status : Int32, @expected_json : String)
    end

    def match(actual_response : HTTP::Client::Response) : Bool
      actual_response.status_code == expected_status &&
        actual_response.body == expected_json
    end

    def failure_message(actual_response : HTTP::Client::Response) : String
      if actual_response.status_code != expected_status
        "Expected status of #{expected_status}. Instead got #{actual_response.status_code}."
      else
        incorrect_response_body_message(actual_response)
      end
    rescue JSON::ParseException
      "Response body is not valid JSON."
    end

    private def incorrect_response_body_message(actual_response : HTTP::Client::Response) : String
      actual_parsed_json = JSON.parse(actual_response.body)
      expected_parsed_json = JSON.parse(expected_json)

      result = expected_parsed_json.as_h.find do |key, value|
        !actual_parsed_json.as_h.has_key?(key) || actual_parsed_json.as_h[key] != value
      end

      pp! result

      "Boo!"
    end

    #   <<-TEXT
    #   Expected response to have JSON key #{key}, but it was not present.

    #   Got keys: #{actual_parsed_json.as_h.keys.join(", ")}
    #   TEXT
    #   break
    # else
    #   "No bueno"
    # end

    def negative_failure_message(actual_value) : String
      "Negative fail!"
    end
  end
end
