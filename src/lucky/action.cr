require "./*"

abstract class Lucky::Action
  getter :context, :route_params

  def initialize(@context : HTTP::Server::Context, @route_params : Hash(String, String))
  end

  abstract def call

  include Lucky::ActionDelegates
  include Lucky::RequestTypeHelpers
  include Lucky::Exposable
  include Lucky::Memoizable
  include Lucky::Routable
  include Lucky::Renderable
  include Lucky::ParamHelpers
  include Lucky::ActionCallbacks
  include Lucky::Redirectable
  include Lucky::VerifyAcceptsFormat
end
