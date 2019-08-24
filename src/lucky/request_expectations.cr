module Lucky::RequestExpectations
  def send_json(status, **expected_response)
    SendJsonExpectation.new(status, expected_response.to_json)
  end

  struct SendJsonExpectation
    def initialize(@status : Int32, @expected_json : String)
    end

    def match(response : HTTP::Client::Response)
      response.status_code == @status && response.body == @expected_json
    end

    def failure_message(response)
      <<-TEXT
    Response JSON does not match.

    Expected:

      Status: #{@status}
      Body: #{@expected_json}

    Actual:

      Status: #{response.status_code}
      Body: #{response.body}
    TEXT
    end

    def negative_failure_message(actual_value)
      "Negative fail!"
    end
  end
end
