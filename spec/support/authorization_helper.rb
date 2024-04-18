module AuthorizationHelper
  def sign_in(user)
    post api_v1_user_session_path, params: {
      email: user.email,
      password: user.password

    }
    # レスポンスのHeadersからトークン認証に必要な要素を抜き出して返す
    response.headers.slice('uid', 'client', 'access-token')
  end
end
