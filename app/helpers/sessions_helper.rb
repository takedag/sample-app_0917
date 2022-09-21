module SessionsHelper

  # 引数に渡されたユーザーオブジェクトでログイン。。
  def log_in(user)
    session[:user_id] = user.id
  end

   # 永続的セッションを記憶。（Userモデルを参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄。
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # セッションと@current_userを破棄。
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 一時的セッションにいるユーザーを返。。
  # それ以外の場合はcookiesに対応するユーザーを返。。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがログイン済みのユーザーであればtrueを返。。
  def current_user?(user)
    user == current_user
  end

  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返。。
  def logged_in?
    !current_user.nil?
  end

  # 記憶しているURL(またはデフォルトURL)にリダイレクト。。
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを記憶。。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
