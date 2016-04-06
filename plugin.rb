# name: Yammer Connect
# about: Authenticate with discourse with yammer, see more at: https://vk.com/developers.php?id=-1_37230422&s=1
# version: 0.1.0
# author: Matthieu Lamarque

class YammerAuthenticator < ::Auth::Authenticator

  def name
    'yammer'
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new
    # grap the info we need from omni auth
    data = auth_token[:info]
    raw_info = auth_token["extra"]["raw_info"]
    name = data["name"]
    yammer_uid = auth_token["uid"]

    # plugin specific data storage
    current_info = ::PluginStore.get("yammer", "yammer_uid_#{yammer_uid}")


    result.user =
      if current_info
        user = User.where(id: current_info[:user_id]).first
      end
    result.email = data["email"]
    result.name = name
    result.extra_data = { yammer_uid: yammer_uid, picture: data["image"] }
    result
  end

  def after_create_account(user, auth)
    data = auth[:extra_data]
    # deactivate/activate it's fix to disable confiramtion mail after creation 
    user.deactivate
    user.activate
    if user
      user.uploaded_avatar_id = UserAvatar.import_url_for_user(data[:picture], user)
       user.save
    end
    user
    user.save
    ::PluginStore.set("yammer", "yammer_uid_#{data[:yammer_uid]}", {user_id: user.id })
  end

  def register_middleware(omniauth)
    omniauth.provider :yammer, :setup => lambda { |env|
      strategy = env['omniauth.strategy']
      strategy.options[:client_id] = SiteSetting.yammer_client_id
      strategy.options[:client_secret] = SiteSetting.yammer_client_secret
    }
  end
end


auth_provider :frame_width => 920,
              :frame_height => 800,
              :authenticator => YammerAuthenticator.new

# We ship with zocial, it may have an icon you like http://zocial.smcllns.com/sample.html
#  in our current case we have an icon for vk

register_css <<CSS

.btn-social.yammer {
  background: #396b9a;
}

.btn-social.yammer:before {
  content: "Y";
}

CSS