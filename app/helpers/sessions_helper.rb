module SessionsHelper

  # 引数に渡されたユーザーオブジェクトでログイン。。
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # セッションと@current_userを破棄。。
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # 現在ログイン中のユーザーがいる場合オブジェクトを返。。
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返。。
  def logged_in?
    !current_user.nil?
  end
end
