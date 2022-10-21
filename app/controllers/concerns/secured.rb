module Secured
  def authenticate_user!
    token_regex = /Bearer (\w+)/
    auth = request.headers['Authorization']

    if auth.present? && auth.match(token_regex)
      token = auth.match(token_regex)[1]
      return if (Current.user = User.find_by(auth_token: token))
    end

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
